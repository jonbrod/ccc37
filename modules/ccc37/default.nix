{
    host,
    ...
}: {
    imports = [
        ./vim
        ./packages.nix
	./mosquitto.nix
	./zigbee.nix
        ./git.nix
        ./ssh.nix
        ./kitty.nix
        ./yazi.nix
    ];
}
