{ ... }:

{
  system.stateVersion = "24.05";

  nix.settings.auto-optimise-store = true;

  dotfiles.enableFanControl = true;
  dotfiles.gpuSupport = "amd";
  dotfiles.enableGaming = true;
  dotfiles.enableVirtualisation = true;
  dotfiles.enableVMWare = true;

  home-manager.users.nhp = {
    home.stateVersion = "24.05";
    dotfiles.zshPromptColor = "cyan";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-windows" ];
}
