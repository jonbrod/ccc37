{ config, pkgs, ... }:
{
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

}
