{
  pkgs,
	...
}:{
	services.nextcloud = {
		enable = true;
		# Verwende eine aktuelle Nextcloud-Version aus den Repos
		package = pkgs.nextcloud29; # oder die jeweils aktuelle stabile Version
		
		hostName = "nextcloud.local"; # Oder deine Domain / lokale IP
		
		# Automatische Einrichtung von Datenbank und Admin-Account
		database.createLocally = true;
		configureApache = true; # Oder nginx, falls du nginx bevorzugst
		
		# Admin-Account Zugangsdaten (kann alternativ auch per sops-nix / secrets verwaltet werden)
		adminpassFile = "/etc/nextcloud-admin-pass"; # Datei mit dem Passwort anlegen
		adminuser = "admin";

		settings = {
			trusted_domains = [
				"localhost"
				"192.168.x.x" # IP deines Servers im Heimnetz
				"nextcloud.local"
			];
			# Standard-Verzeichnis für Benutzerdaten (kann auf eine große Festplatte ausgelagert werden)
			datadirectory = "/var/lib/nextcloud";
		};
	};
}
