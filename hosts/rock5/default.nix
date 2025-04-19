{ pkgs, ... }:

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

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0729-785F";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-rock5";
    fsType = "ext4";
  };

  boot.kernelPackages = pkgs.linuxPackages_testing;

  boot.initrd.availableKernelModules = [
    # From all-hardware.nix, should make graphics available early
    "dw-hdmi"
    "dw-mipi-dsi"
    "rockchipdrm"
    "rockchip-rga"
    "phy-rockchip-pcie"
    "pcie-rockchip-host"
  ];

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    deviceTree.enable = true;
    deviceTree.name = "rockchip/rk3588s-rock-5a.dtb";
  };

  environment.sessionVariables = {
    PAN_MESA_DEBUG = "gl3";
    KWIN_COMPOSE = "O2ES";
  };

  # The system does not seem to respond to keyboard/mouse input to wake
  # and I can't reach the power button when it's in a case
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';
}
