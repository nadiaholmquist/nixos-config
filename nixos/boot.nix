{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    dotfiles.bootloader = lib.mkOption {
      type = lib.types.enum [
        "systemd-boot"
        "grub"
      ];
      default = "systemd-boot";
      description = "Which bootloader to use";
    };
  };

  config = {
    boot = {
      #kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      loader = {
        timeout = 15;
        efi.canTouchEfiVariables = false;

        systemd-boot = lib.mkIf (config.dotfiles.bootloader == "systemd-boot") {
          enable = true;
          graceful = true;
        };

        grub = lib.mkIf (config.dotfiles.bootloader == "grub") {
          enable = true;
          device = "nodev";
          efiSupport = true;
          # Do not depend on entry in NVRAM to boot
          efiInstallAsRemovable = true;
          useOSProber = true;
          default = "saved";

          splashImage = null;
          backgroundColor = "#121212";
          theme = pkgs.sleek-grub-theme.override {
            withBanner = config.networking.hostName;
            withStyle = "dark";
          };
        };
      };

      initrd.systemd.enable = true;

      plymouth.enable = true;

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
        "plymouth.use-simpledrm"
      ];
    };
  };
}
