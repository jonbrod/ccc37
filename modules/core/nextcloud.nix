{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;          # Version immer fest angeben
    hostName = "cloud.deinedomain.de";
    https = true;

    database.createLocally = true;       # legt PostgreSQL automatisch an
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/var/lib/secrets/nextcloud-admin-pass";
    };

    configureRedis = true;               # Caching / Dateisperren
    maxUploadSize = "16G";

    settings = {
      default_phone_region = "DE";
      maintenance_window_start = 1;      # Wartung nachts (UTC)
    };

    # Apps deklarativ installieren
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar contacts tasks notes deck;
    };
    extraAppsEnable = true;
  };

  # HTTPS mit Let's Encrypt
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "du@deinedomain.de";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
