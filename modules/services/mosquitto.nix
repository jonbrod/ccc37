{ pkgs, ... }: {
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "127.0.0.1";
        port = 1883;
        omitPasswordAuth = true;
        acl = [ "pattern readwrite #" ];
        settings.allow_anonymous = true;
      }
    ];
  };
}
