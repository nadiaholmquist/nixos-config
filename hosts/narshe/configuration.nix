{ ... }:

{
  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

  dotfiles.enableFanControl = true;
  dotfiles.gpuSupport = "amd";
  dotfiles.enableROCm = true;
  dotfiles.enableGaming = true;
  dotfiles.enableVirtualisation = true;
  dotfiles.enableVMWare = true;
  dotfiles.autoLogin = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "cyan";
  };

  fonts.fontconfig.hinting.enable = false;
  fonts.fontconfig.hinting.style = "none";
  fonts.fontconfig.subpixel.rgba = "none";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-windows" ];
}
