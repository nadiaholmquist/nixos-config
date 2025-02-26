{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.pine64-pinebook-pro
  ];

  system.stateVersion = "24.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Something sets this to true despite this being aarch64-linux, idk why
  hardware.graphics.enable32Bit = lib.mkForce false;

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
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nixos-efi";
    fsType = "vfat";
  };

  zramSwap.enable = true;
}
