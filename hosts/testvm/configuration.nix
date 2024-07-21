{ ... }:

{
  system.stateVersion = "24.05";

  dotfiles.enableFanControl = false;
  dotfiles.gpuSupport = null;
  dotfiles.enableGaming = false;
  dotfiles.autoLogin = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "magenta";
  };

  virtualisation.vmVariant = {
    virtualisation.cores = 8;
    virtualisation.memorySize = 4096;
    virtualisation.qemu.options = [
      "-device" "virtio-gpu-gl"
      "-display" "gtk,gl=on"
    ];
  };
}
