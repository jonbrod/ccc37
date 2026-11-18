{ 
  config, 
  pkgs, 
  ... 
}: {
  # SSH-Konfiguration
  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      hostname = "github.com";
      user = "git"; # Erzwingt den User für diesen Host
      identityFile = "/home/jonbrod/.ssh/github";    
    };
  };
}
