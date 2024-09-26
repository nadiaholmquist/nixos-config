{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.enable = true;

    plymouth.enable = true;
  };
}
