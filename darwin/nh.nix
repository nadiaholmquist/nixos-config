{
  pkgs,
  config,
  ...
}:

{
  environment.systemPackages = [
    pkgs.nh
  ];

  environment.variables.NH_FLAKE = "/private/etc/nix-darwin#darwinConfigurations.${config.networking.hostName}";
}
