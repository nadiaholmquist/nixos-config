{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.dotfiles.gpuSupport == "amd") {
    hardware.amdgpu.opencl.enable = true;
    hardware.amdgpu.initrd.enable = true;

    # HIP workaround from the wiki
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    #hardware.amdgpu.amdvlk.enable = true;
    # Default to RADV
    #environment.variables.AMD_VULKAN_ICD = "RADV";

    # Occasionally useful utils
    environment.defaultPackages = with pkgs; [
      vulkan-tools glxinfo libva-utils
    ];
  };
}
