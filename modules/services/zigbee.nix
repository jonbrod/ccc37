{
  pkgs,
  ...
}: {
	services.zigbee2mqtt = {
	  enable = true;
	  settings = {
	    homeassistant.enabled = true; # Aktiviert die automatische Erkennung in Home Assistant (falls genutzt)
	    permit_join = false;  # Standardmäßig keine neuen Geräte zulassen (Sicherheit)
	    serial = {
	      port = "/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_5229ba8b24f1ef1184d3c50a6d9880ab-if00-port0";
	      # Bei manchen Sticks (z.B. Sonoff ZBDongle-P) ist adapter = "zstack" nötig,
	      # neuere (z.B. ZBDongle-E) nutzen oft "ember" oder "ezsp".
	      adapter = "ember"; 
	    };
	    frontend = {
	      port = 8080; # Web-Oberfläche von Zigbee2MQTT
	      host = "0.0.0.0";
	    };
	    advanced = {
	      network_key = [ 1 3 5 7 9 11 13 15 0 2 4 6 8 10 12 13 ]; # Generiere am besten einen eigenen zufälligen Key
	    };
	  };
	};
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8080 ];
}
