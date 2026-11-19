{ config, pkgs, ... }:

let
  inherit (vars = import ../../hosts/${host}/vars.nix) tshost;
in
{
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
  
  systemd.services.grafana.serviceConfig.LoadCredential = [
    "admin_pass:/var/lib/secrets/grafana-admin-pass"
    "secret_key:/var/lib/secrets/grafana-secret-key"
  ];

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3000 ];
}
