{ 
    pkgs,
    ...
}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "jonbrod";
      email = "jonathanbrodka@gmail.com";
    };
  };
}
