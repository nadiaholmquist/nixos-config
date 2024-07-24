{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  # nct6775 is required for temp sensors/fan control
  boot.kernelModules = [ "kvm-amd" "nct6775" ];
  boot.blacklistedKernelModules = ["k10temp"];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
