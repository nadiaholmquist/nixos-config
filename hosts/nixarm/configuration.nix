{ ... }:

{
  system.stateVersion = "24.05";

  dotfiles.enableFanControl = false;
  dotfiles.gpuSupport = null;
  dotfiles.enableGaming = false;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "magenta";
  };
}
