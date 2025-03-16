{ ... }:

{
  system.stateVersion = "24.05";

  dotfiles = {
    enableFanControl = true;
    gpuSupport = "amd";
    enableROCm = false;
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

  fonts.fontconfig.hinting.enable = false;
  fonts.fontconfig.hinting.style = "none";
  fonts.fontconfig.subpixel.rgba = "none";

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "x86_64-windows"
  ];

  dotfiles.builders = {
    enable = true;
    useMacStudio = true;
  };

  nix.distributedBuilds = false;
}
