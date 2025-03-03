{
  pkgs,
  lib,
  config,
  ...
}:

{
  system.stateVersion = "24.11";

  dotfiles.enableFanControl = false;
  dotfiles.gpuSupport = null;
  dotfiles.enableGaming = false;
  dotfiles.autoLogin = false;
  dotfiles.enableVirtualisation = false;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "magenta";
    dotfiles.enableLargeApps = false;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-rock5";
    fsType = "ext4";
  };

  boot = {
    loader.grub.enable = lib.mkForce false;
    loader.generic-extlinux-compatible.enable = true;

    kernelPackages = lib.mkForce (
      pkgs.callPackage ./kernel.nix {
        inherit (config.boot) kernelPatches;
      }
    );
  };

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    deviceTree.enable = true;
    deviceTree.name = "rockchip/rk3588s-rock-5a.dtb";
  };

  # It definitely does not need all those but I don't want to mess with it
  boot.initrd.availableKernelModules = [
    "usbhid"
    "md_mod"
    "raid0"
    "raid1"
    "raid10"
    "raid456"
    "ext2"
    "ext4"
    "sd_mod"
    "sr_mod"
    "mmc_block"
    "uhci_hcd"
    "ehci_hcd"
    "ehci_pci"
    "ohci_hcd"
    "ohci_pci"
    "xhci_hcd"
    "xhci_pci"
    "usbhid"
    "hid_generic"
    "hid_lenovo"
    "hid_apple"
    "hid_roccat"
    "hid_logitech_hidpp"
    "hid_logitech_dj"
    "hid_microsoft"
    "hid_cherry"
  ];
}
