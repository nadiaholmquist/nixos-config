{ pkgs, lib, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
}