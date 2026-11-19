{
  ...
}: {
  imports = [
    ./dashboard             # Port 80
    ./grafana.nix           # Port 3000 
    ./homeassistant.nix     # Port 8123
    ./mosquitto.nix
    ./nextcloud.nix         # Port 8001
    ./telegraf.nix  
    ./victoriametrics.nix
    ./zigbee.nix            # Port 8080
  ];
}
