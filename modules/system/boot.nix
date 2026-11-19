{
  pkgs,
  config,
  ...
}: {
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "/dev/nvme0n1";
  };
}
