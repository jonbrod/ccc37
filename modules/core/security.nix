{
  inputs,
  config,
  ...
}: {
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];
  services.openssh.enable = true;
  
  nix.extraOptions = ''
    !include /etc/nix/github-token.conf
  '';
  security.rtkit.enable = true;
}