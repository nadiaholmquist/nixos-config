{ ... }:

{
  system.stateVersion = "24.05";

  dotfiles = {
    bootloader = "grub";
    enableFanControl = true;
    gpuSupport = "amd";
    enableROCm = true;
    enableGaming = true;
    enableGPUOverclocking = true;
    enableVirtualisation = true;
    enableVMWare = false;
    autoLogin = false;
  };

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "cyan";
  };

  fonts.fontconfig.subpixel.rgba = "none";

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "x86_64-windows"
  ];

  dotfiles.builders = {
    enable = true;
    useBuilderVMs = false;
    useMacStudio = true;
  };

  nix.settings.system-features = [ "gccarch-znver3" ];
}
