{ inputs, ... }:

{
  common = [
    ./autologin.nix
    ./locale.nix
    ./users.nix
    ./vm-variant.nix
    ./programs.nix
  ];

  desktop = [
    ./boot.nix
    ./desktop-environment.nix
    ./fonts.nix
    ./gaming.nix
    ./hardware.nix
    ./services.nix
    ./virtualisation.nix
  ];

  wsl = [
    inputs.nixos-wsl.nixosModules.default
    ./wsl.nix
  ];
}
