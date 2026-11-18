# nextcloud.nix
# Nextcloud – nur über Tailscale erreichbar (kein öffentlicher Zugang)
{ config, pkgs, ... }:

let
  # Tailscale-Name des Servers (steht in `tailscale status` bzw. im Admin-Panel)
  tsHost = "ccc37.dein-tailnet.ts.net";   # <- anpassen
in
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;          # Version immer fest angeben
    hostName = tsHost;
    https = false;                       # Tailscale verschlüsselt den Verkehr bereits

    database.createLocally = true;       # legt PostgreSQL automatisch an
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/var/lib/secrets/nextcloud-admin-pass";
    };

    configureRedis = true;
    maxUploadSize = "16G";

    settings = {
      # zusätzlich erlaubte Adressen (Kurzname über MagicDNS)
      trusted_domains = [ "ccc37" ];
      default_phone_region = "DE";
      maintenance_window_start = 1;      # Wartung nachts (UTC)
    };

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar contacts tasks notes deck;
    };
    extraAppsEnable = true;
  };

  # Nextcloud auch ausliefern, wenn der Server über Kurzname oder IP aufgerufen wird
  services.nginx.virtualHosts.${tsHost}.default = true;

  # Port 80 NUR im Tailscale-Netz öffnen, nicht nach außen
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 80 ];
}
