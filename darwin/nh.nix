{
  pkgs,
  config,
  ...
}:

{

  environment.systemPackages = [
    pkgs.nh
  ];

  environment.variables.NH_FLAKE = "/etc/nix-darwin#darwinConfigurations.${config.networking.hostName}";
}
