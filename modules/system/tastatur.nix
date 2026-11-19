{
  lib,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/vars.nix;
  xkbLayout = vars.keyboardLayout or "de";
  xkbVariant = vars.keyboardVariant or "";
  consoleKeyMap = vars.consoleKeyMap or "de";
in {
  # Tastaturlayout der Konsole
  console.keyMap = consoleKeyMap;

  # Tastaturlayout für den Wayland-Greeter (cage/ReGreet) und die
  # Usersession: wlroots-basierte Compositoren lesen XKB_DEFAULT_*.
  # (services.xserver.xkb hätte ohne X-Server keine Wirkung.)
  systemd.services.greetd.environment = {
    XKB_DEFAULT_LAYOUT = xkbLayout;
  }
    // lib.optionalAttrs (xkbVariant != "") {
      XKB_DEFAULT_VARIANT = xkbVariant;
    };
}
