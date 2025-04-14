{ inputs, ... }:

{
  common = [
    ./autologin.nix
    ./locale.nix
    ./users.nix
    ./vm-variant.nix
    ./overlay.nix
    ./programs.nix
    ./nix-settings.nix
    ../common/builders.nix
  ];

  desktop = [
    ./boot.nix
    ./desktop-environment.nix
    ./fonts.nix
    ./gaming.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./virtualisation.nix
  ];

  wsl = [
    inputs.nixos-wsl.nixosModules.default
    ./wsl.nix
  ];
}
