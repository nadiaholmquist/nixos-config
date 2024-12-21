{ pkgs, lib, inputs, config, ... }:

{
  assertions = [
    {
      assertion = lib.versionOlder pkgs.nh.version "4.0";
      message = "nh ${pkgs.nh.version} is now in nixpkgs, drop the flake input.";
    }
  ];

  environment.systemPackages = [
    inputs.nh.packages.${config.nixpkgs.system}.nh
  ];

  environment.variables.NH_FLAKE = "/etc/nix-darwin#darwinConfigurations.${config.networking.hostName}";
}
