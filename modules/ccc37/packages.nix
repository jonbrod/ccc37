{
    pkgs,
    host,
    ...
}: let
    inherit (import ../../../hosts/${host}/vars.nix) gitUsername gitEmail userPrivat;
in {
    home.packages = with pkgs; [
        firefox
        kitty

        direnv
        nix-direnv

    ];
    
    programs = {
        direnv = {
            enable = true;
            enableBashIntegration = true; # see note on other shells below
            nix-direnv.enable = true;
        };

        bash.enable = true; # see note on other shells below
    };

    home = {
        sessionPath = ["/home/jonbrod/.bin"];
    };
}   
