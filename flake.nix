
{
  description = "homeOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    yazi.url = "github:sxyazi/yazi";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { 
    self, 
    nixpkgs, 
    nixvim,
    home-manager, 
    nix-flatpak,
    yazi,
    ... 
  }@ inputs: let
    system = "x86_64-linux";
    host = "ccc37";
    profile = "amd";
    username = "ccc37";

    mkNixosConfig = gpuProfile:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile; # keep using the let-bound profile for modules/scripts
        };
        modules = [
          ({ pkgs, ... }: {
						environment.systemPackages = [
							(yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
								_7zz = pkgs._7zz-rar;  # Support for RAR extraction
							})
						];
					})
          ./profiles/${gpuProfile}
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
  in
  {
    nixosConfigurations = {
      amd = mkNixosConfig "amd";
      nvidia = mkNixosConfig "nvidia";
      laptop = mkNixosConfig "nvidia-laptop";    #nvidia-laptop
      amd-nvidia-hybrid = mkNixosConfig "amd-nvidia-hybrid";
      intel = mkNixosConfig "intel";
      vm = mkNixosConfig "vm";
    };
  };
}
