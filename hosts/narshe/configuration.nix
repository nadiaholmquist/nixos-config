{ pkgs, ... }:

{
  system.stateVersion = "24.05";

  dotfiles.enableFanControl = true;
  dotfiles.gpuSupport = "amd";
  dotfiles.enableGaming = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "cyan";
  };
}
