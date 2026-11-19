{ config, pkgs, ... }:

let
  inherit (vars = import ../../hosts/${host}/vars.nix) tshost;
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
}
