{ ... }:

{
  system.stateVersion = "24.05";

  dotfiles.enableFanControl = false;
  dotfiles.gpuSupport = null;
  dotfiles.enableGaming = false;
  dotfiles.autoLogin = true;
  dotfiles.enableVirtualisation = false;

  #virtualisation.rosetta.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "magenta";
  };
}
