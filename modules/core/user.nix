{
  pkgs,
  inputs,
  username,
  host,
  profile,
  ...
}: let
  inherit (import ../../hosts/${host}/vars.nix) gitUsername gitEmail;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      inputs.nixvim.homeModules.nixvim # Nixvim für Home Manager laden
    ];
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username host profile pkgs;};
    users.ccc37 = {
      imports = [./../ccc37];
      home = {
        username = "ccc37";
        homeDirectory = "/home/ccc37";
        stateVersion = "26.05";
      };
    };
  };
  users.mutableUsers = true;
  users.users.ccc37 = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "libvirtd" #Virt manager/QEMU access
      "kvm" #direct /dev/kvm access
      "networkmanager"
      "wheel" #sudo access
    ];
    shell = pkgs.bash;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "root" "ccc37"];
}
