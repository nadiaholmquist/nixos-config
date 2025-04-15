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
    dotfiles = {
      zshPromptColor = "magenta";
      enableLargeApps = true;
      enableJetBrains = false;
    };
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/0729-785F";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-rock5";
    fsType = "ext4";
  };
  
  boot.kernelPackages = pkgs.linuxPackages_testing;

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    deviceTree.enable = true;
    deviceTree.name = "rockchip/rk3588s-rock-5a.dtb";
  };

  environment.sessionVariables = {
    PAN_MESA_DEBUG = "gl3";
    KWIN_COMPOSE = "O2ES";
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

  # The system does not seem to respond to keyboard/mouse input to wake
  # and I can't reach the power button when it's in a case
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';
}
