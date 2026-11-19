{
  ...
}: {
  imports = [
    ./grafana.nix           # Port 3000 
    ./homeassistant.nix     # Port 8123
    ./mosquitto.nix
    ./nextcloud.nix         # Port 80
    ./telegraf.nix  
    ./victoriametrics.nix
    ./zigbee.nix            # Port 8080
  ];
}
