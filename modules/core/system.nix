{
  pkgs,
  host,
  config, 
  ...
}: let
  vars = import ../../hosts/${host}/vars.nix;
in {
  nix = {
    settings = {
      download-buffer-size = 200000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs.nix-ld.enable = true;

  services = {
    libinput.enable = true;
    dbus.packages = [
      pkgs.dbus.out
      config.system.path
    ];
  };
  
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    pathsToLink = [ "/etc/dbus-1" "/share/dbus-1" ];
  };

  environment.systemPackages = with pkgs; [
      pciutils # Collection Of Tools For Inspecting PCI Devices
  ];

  system.stateVersion = "26.05";
}