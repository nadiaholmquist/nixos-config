{ lib, home-manager, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nhp";

  home-manager.users.nhp = {
    dotfiles.enableHomeGuiApps = lib.mkDefault false;
  };
}
