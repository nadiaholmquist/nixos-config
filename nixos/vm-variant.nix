{ lib, pkgs, ... }:

let
  vmOptions = {
    dotfiles.enableFanControl = lib.mkForce false;
    dotfiles.gpuSupport = lib.mkForce null;
    dotfiles.enableGaming = lib.mkForce false;

    virtualisation.cores = 8;
    virtualisation.memorySize = 4096;
    virtualisation.qemu.options = lib.mkIf (pkgs.stdenv.isx86_64) [
      "-M q35"
      "-vga none" # Default VGA conflicts with the virtio-gpu device
      "-device virtio-vga-gl,blob=on,hostmem=4G,venus=on"
      "-display sdl,gl=on"
      "-audio driver=pipewire,model=virtio"
    ];

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
in
{
  virtualisation.vmVariant = vmOptions;
  virtualisation.vmVariantWithBootLoader = vmOptions;
}
