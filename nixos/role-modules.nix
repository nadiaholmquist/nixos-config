{ inputs, ... }:

{
  common = [
    ./autologin.nix
    ./locale.nix
    ./users.nix
    ./vm-variant.nix
    ./overlay.nix
    ./programs.nix
    ../common/builders.nix
    ../common/nix-settings.nix
  ];

  desktop = [
    ./boot.nix
    ./desktop-environment.nix
    ./fonts.nix
    ./gaming.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./sound.nix
    ./virtualisation.nix
  ];

  wsl = [
    inputs.nixos-wsl.nixosModules.default
    ./wsl.nix
  ];
}
