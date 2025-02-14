{ ... }:

{
  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

  dotfiles.enableFanControl = true;
  dotfiles.gpuSupport = "amd";
  dotfiles.enableROCm = false;
  dotfiles.enableGaming = true;
  dotfiles.enableVirtualisation = true;
  dotfiles.enableVMWare = false;
  dotfiles.autoLogin = false;

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
