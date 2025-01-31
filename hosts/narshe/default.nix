{ ... }:

{
  dotfiles.builders = {
    enable = true;
    useMacStudio = true;
  };

  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
  ];
}
