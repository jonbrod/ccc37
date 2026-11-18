{
  pkgs,
  ...
}: {
  services.mosquitto = {
    enable = true;
    settings = {
      listener = [{
        port = 1883;
        address = "127.0.0.1"; # Lauscht standardmäßig nur lokal
      }];
      allow_anonymous = true; # Für den Heimgebrauch (kann später abgesichert werden)
    };
  };
}
