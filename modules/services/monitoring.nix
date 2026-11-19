# monitoring.nix
# Zigbee2MQTT -> Telegraf -> VictoriaMetrics -> Grafana
# Grafana nur über Tailscale erreichbar
#
# Datenfluss:
#   Sensor -> Zigbee2MQTT -> Mosquitto (MQTT)
#          -> Telegraf liest mit
#          -> VictoriaMetrics speichert dauerhaft
#          -> Grafana zeigt Dashboards
{ config, pkgs, ... }:

let
  # Tailscale-Name des Servers (steht in `tailscale status` bzw. im Admin-Panel)
  tsHost = "ccc37.tailb8dd11.ts.net";   # <- anpassen
in
{
  # ---------------------------------------------------------------
  # 1. VictoriaMetrics – Zeitreihen-Datenbank
  # ---------------------------------------------------------------
  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:8428";   # nur lokal auf dem Server
    retentionPeriod = "5y";             # Daten 5 Jahre aufbewahren
  };

  # ---------------------------------------------------------------
  # 2. Telegraf – liest MQTT mit und schreibt in VictoriaMetrics
  # ---------------------------------------------------------------
  services.telegraf = {
    enable = true;

    # Nur nötig, wenn Mosquitto ein Passwort verlangt.
    # Datei-Inhalt:  MQTT_PASSWORD=deinpasswort
    # environmentFiles = [ "/var/lib/secrets/telegraf.env" ];

    extraConfig = {
      agent = {
        flush_interval = "10s";
	debug = true;
      };

      inputs.mqtt_consumer = [
        {
          servers = [ "tcp://127.0.0.1:1883" ];
          # "+" = genau eine Ebene -> nur Geräte-Nachrichten,
          # nicht zigbee2mqtt/bridge/... oder .../availability
          topics = [ "zigbee2mqtt/+" ];
          client_id = "telegraf";
          qos = 1;
          persistent_session = false;

          # username = "telegraf";
          # password = "\${MQTT_PASSWORD}";

          data_format = "json";
          name_override = "zigbee";       # Metriken heißen dann zigbee_temperature usw.
          tagexclude = [ "topic" ];       # Gerätename kommt als eigener Tag
          fieldexclude = [ "update_*" ];  # Firmware-Update-Infos nicht speichern

          # Gerätename aus dem Topic als Tag "device" übernehmen
          topic_parsing = [
            {
              topic = "zigbee2mqtt/+";
              tags = "_/device";
            }
          ];
        }
      ];

      # VictoriaMetrics versteht das InfluxDB-Protokoll direkt
      outputs.influxdb = [
        {
          urls = [ "http://127.0.0.1:8428" ];
          database = "zigbee";
          skip_database_creation = true;
        }
      ];
    };
  };

  # ---------------------------------------------------------------
  # 3. Grafana – Dashboards
  # ---------------------------------------------------------------
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "0.0.0.0";           # Firewall lässt nur Tailscale durch (siehe unten)
        http_port = 3000;
        domain = tsHost;
        root_url = "http://${tsHost}:3000/";
      };

      security = {
        admin_user = "admin";
        # Secrets werden per systemd-Credential übergeben,
        # damit sie nicht im Nix Store landen.
        admin_password = "$__file{/run/credentials/grafana.service/admin_pass}";
        secret_key = "$__file{/run/credentials/grafana.service/secret_key}";
      };

      analytics.reporting_enabled = false;
    };

    # Datenquelle automatisch anlegen
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "VictoriaMetrics";
          type = "prometheus";   # VictoriaMetrics ist Prometheus-kompatibel
          url = "http://127.0.0.1:8428";
          isDefault = true;
        }
      ];
    };
  };

  # Secret-Dateien gehören root (chmod 400), systemd reicht sie an Grafana weiter
  systemd.services.grafana.serviceConfig.LoadCredential = [
    "admin_pass:/var/lib/secrets/grafana-admin-pass"
    "secret_key:/var/lib/secrets/grafana-secret-key"
  ];

  # Port 3000 NUR im Tailscale-Netz öffnen, nicht nach außen
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3000 ];
}
