{
  pkgs,
  config,
  host,
  ...
}: let
  inherit (import ../../hosts/${host}/vars.nix) intelID nvidiaID;
in {
 programs.xwayland.enable = true;
}
