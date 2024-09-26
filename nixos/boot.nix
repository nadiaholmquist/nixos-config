{ pkgs, lib, config, ... }:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;
      efi.canTouchEfiVariables = false;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        # Do not depend on entry in NVRAM to boot
        efiInstallAsRemovable = true;
        useOSProber = true;

        splashImage = null;
        theme = pkgs.sleek-grub-theme.override {
          withBanner = config.networking.hostName;
          withStyle = "dark";
        };
      };
    };

    initrd.systemd.enable = true;

    plymouth.enable = true;
  };
}
