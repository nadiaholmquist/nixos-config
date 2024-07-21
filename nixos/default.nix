{ lib, ...}:

with lib;
{
  options = {
    dotfiles.enableGaming = mkEnableOption "Enable packages for gaming support.";
    dotfiles.enableFanControl = mkOption {
      type = types.bool;
      description = "Enable userspace fan control.";
      default = false;
    };
    dotfiles.gpuSupport = mkOption {
      description = "Add extra packages for supporting a GPU.";
      type = with types; nullOr (enum ["amd"]);
      default = null;
    };
  };

  imports = [
    ./configuration.nix
    ./users.nix
    ./system-packages.nix
    ./desktop-environment.nix
    ./fonts.nix
    ./virtualisation.nix
    ./logitech-wireless.nix
    ./amd-gpu.nix
    ./gaming.nix
    ./fan-control.nix
    ./nh.nix
  ];
}
