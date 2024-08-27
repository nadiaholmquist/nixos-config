{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;

    plymouth.enable = true;
  };
}
