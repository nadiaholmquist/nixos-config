{ pkgs, lib, config, ... }:

let
  inherit (lib) mkOption mkIf mkMerge types;
in {
  options = {
    dotfiles.enableFanControl = mkOption {
      type = types.bool;
      description = "Enable userspace fan control.";
      default = false;
    };
    dotfiles.gpuSupport = mkOption {
      description = "Add extra packages for supporting a GPU.";
      type = with types; nullOr (enum ["amd"]);
      default = null;
    };
  };

  config = mkMerge [
    # General hardware support
    {
      # Enable sound with pipewire.
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      # Bluetooth
      hardware.bluetooth.enable = true;

      # Enable firmware updates
      services.fwupd.enable = true;

      # Logitech
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = true;

      environment.etc = {
        # High-resolution scrolling on Linux is too janky to use because of the weird deadzone behavior that I can't find a way to disable.
        # So just disable it entirely for now :(
        "libinput/local-overrides.quirks".text = ''
          [Logitech MX Master 3]
          MatchVendor=0x46D
          MatchProduct=0x4082
          AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;

          # MX Master 3 has a different PID on bluetooth
          [Logitech MX Master 3]
          MatchVendor=0x46D
          MatchProduct=0xB023
          AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES
        '';
      };
    }

    # AMD GPU specific settings
    (mkIf (config.dotfiles.gpuSupport == "amd") {
      hardware.amdgpu.opencl.enable = true;
      hardware.amdgpu.initrd.enable = true;

      # ROCm workaround from the wiki
      systemd.tmpfiles.rules = let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
      };
      in [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];

      #hardware.amdgpu.amdvlk.enable = true;
      # Default to RADV
      #environment.variables.AMD_VULKAN_ICD = "RADV";

      # Occasionally useful utils
      environment.defaultPackages = with pkgs; [
        vulkan-tools glxinfo libva-utils
      ];
    })

    # Userspace fan control
    (mkIf config.dotfiles.enableFanControl {
      programs.coolercontrol.enable = true;
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    })
  ];
}
