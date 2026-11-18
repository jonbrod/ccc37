{ 
  config, 
  pkgs, 
  ... 
}: {
  # SSH-Konfiguration
  programs.ssh = {
    enable = true;
    matchBlocks."ccc37" = {
      hostname = "192.168.42.99"; # Trage hier die lokale IP-Adresse deines PCs ein (z.B. 192.168.1.50)
      user = "ccc37";
      # Zeige auf den privaten Key (du kannst ihn z.B. unverschlüsselt im Home-Verzeichnis liegen lassen 
      # oder noch sicherer über agenix verwalten, wenn er absolut geheim sein muss)
      identityFile = "/home/ccc37/.ssh/ccc37";
    };
  };}
