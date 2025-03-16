{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkMerge
    types
    ;

  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    enableFanControl = mkEnableOption "Enable userspace fan control.";
    enableROCm = mkEnableOption "Enable AMD ROCm";
    enableGPUOverclocking = mkEnableOption "Enable GPU overclocking.";

    gpuSupport = mkOption {
      description = "Add extra packages for supporting a GPU.";
      type = with types; nullOr (enum [ "amd" ]);
      default = null;
    };
  };

  config = mkMerge [
    # General hardware support
    {
      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # Sets LD_LIBRARY_PATH globally, breaks stuff
        #jack.enable = true;
        wireplumber.enable = true;
      };

      # Bluetooth
      hardware.bluetooth.enable = true;

      # Enable firmware updates
      services.fwupd.enable = true;

      # Logitech
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = true;
    }

    # AMD GPU specific settings
    (mkIf (cfg.gpuSupport == "amd") {
      hardware.amdgpu.initrd.enable = true;

      #hardware.amdgpu.amdvlk.enable = true;
      # Default to RADV
      #environment.variables.AMD_VULKAN_ICD = "RADV";
    })

    (mkIf (cfg.gpuSupport == "amd" && cfg.enableGPUOverclocking == true) {
      boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

      environment.systemPackages = [ pkgs.lact ];
      systemd.packages = [ pkgs.lact ];
      systemd.services.lactd.wantedBy = [ "multi-user.target" ];
    })

    (mkIf cfg.enableROCm {
      nixpkgs.config.rocmSupport = true;

      hardware.amdgpu.opencl.enable = true;

      # ROCm workaround from the wiki
      systemd.tmpfiles.rules =
        let
          rocmEnv = pkgs.symlinkJoin {
            name = "rocm-combined";
            paths = with pkgs.rocmPackages; [
              rocblas
              hipblas
              clr
            ];
          };
        in
        [
          "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
        ];
    })

    # Userspace fan control
    (mkIf cfg.enableFanControl {
      programs.coolercontrol.enable = true;
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    })
  ];
}
