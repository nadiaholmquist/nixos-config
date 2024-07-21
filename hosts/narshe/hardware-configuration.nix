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

  #fileSystems."/" =
  #  { device = "/dev/disk/by-uuid/acedbb0c-b63c-4f28-9d7e-7c1bd3e49e52";
  #    fsType = "ext4";
  #  };

  #fileSystems."/boot" =
  #  { device = "/dev/disk/by-uuid/4645-B34E";
  #    fsType = "vfat";
  #    options = [ "fmask=0022" "dmask=0022" ];
  #  };

  #swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
