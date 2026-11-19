{ config, pkgs, ... }:
{
  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:8428";   # nur lokal auf dem Server
    retentionPeriod = "5y";             # Daten 5 Jahre aufbewahren
  };
}
