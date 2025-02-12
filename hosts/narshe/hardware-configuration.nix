{ modulesPath, inputs, ... }:

let
  hw = inputs.nixos-hardware.nixosModules;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    hw.common-cpu-amd-zenpower
    hw.common-cpu-amd-pstate
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];

  # nct6775 is required for temp sensors/fan control
  boot.kernelModules = [
    "kvm-amd"
    "nct6775"
  ];
}
