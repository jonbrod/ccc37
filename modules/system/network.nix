{
  pkgs,
  host,
  options,
  ...
}: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
    useDHCP = false;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [{
        address = "192.168.42.99";
	prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.42.1";
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
