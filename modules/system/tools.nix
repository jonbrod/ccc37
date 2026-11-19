{
  pkgs,
  inputs,
  ...
} : {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    zip unzip
    btop yazi
    ripgrep fd jq curl wget
    git lazygit openssh
    
    brightnessctl # For Screen Brightness Control
    tailscale # For VPN

    grim    # scrennshot
    slurp   # selection tool for screenshots
  ];

  services.tailscale.enable = true;
}
