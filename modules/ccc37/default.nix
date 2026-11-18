{
    host,
    ...
}: {
    imports = [
        ./vim
        ./packages.nix
        ./git.nix
        ./ssh.nix
        ./kitty.nix
        ./yazi.nix
    ];
}
