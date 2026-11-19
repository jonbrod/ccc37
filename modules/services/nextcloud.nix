# nextcloud.nix
# Nextcloud – nur über Tailscale erreichbar (kein öffentlicher Zugang)
{ host, config, pkgs, ... }:

let
  vars = import ../../hosts/${host}/vars.nix;
in
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;          # Version immer fest angeben
    hostName = vars.tsHost;
    https = false;                       # Tailscale verschlüsselt den Verkehr bereits

    database.createLocally = true;       # legt PostgreSQL automatisch an
    config = {
      dbtype = "pgsql";
    };

    configureRedis = true;
    maxUploadSize = "16G";

    settings = {
      # zusätzlich erlaubte Adressen (Kurzname über MagicDNS)
      trusted_domains = [ vars.tsHost "ccc37" ];
      default_phone_region = "DE";
      maintenance_window_start = 1;      # Wartung nachts (UTC)
    };

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar contacts tasks notes deck;
    };
    extraAppsEnable = true;
  };
# Nginx wird vom Nextcloud-Modul aktiviert – hier den Port umbiegen
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    listen = [
      { addr = "0.0.0.0"; port = 8000; ssl = false; }
    ];
  };

  # Port 8000 NUR im Tailscale-Netz öffnen
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8000 ];
}
