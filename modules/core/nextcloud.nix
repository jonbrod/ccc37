{
  pkgs,
	...
}:{
	services.nextcloud = {
		enable = true;
		# Verwende eine aktuelle Nextcloud-Version aus den Repos
		package = pkgs.nextcloud29; # oder die jeweils aktuelle stabile Version
		
		hostName = "nextcloud.local"; # Oder deine Domain / lokale IP
		database.createLocally = true;
		configureApache = true; # Oder nginx, falls du nginx bevorzugst

		settings = {
			trusted_domains = [
				"localhost"
				"192.168.42.99" # IP deines Servers im Heimnetz
				"nextcloud.local"
			];
			# Standard-Verzeichnis für Benutzerdaten (kann auf eine große Festplatte ausgelagert werden)
			datadirectory = "/var/lib/nextcloud";
		};
	};
}
