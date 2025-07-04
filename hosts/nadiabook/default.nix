{ ... }:

{
  system.stateVersion = 5;

  dotfiles.builders.enable = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "green";
    dotfiles.enableGaming = false;
    dotfiles.enableLargeApps = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
