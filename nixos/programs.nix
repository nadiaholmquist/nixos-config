{ lib, pkgs, ... }:

{
  environment.systemPackages =
    (with pkgs; [
      git
      file
      wget
      python3
      dig
      killall
      rsync
      gnumake

      alsa-utils

      stress-ng
    ])
    ++ lib.optionals pkgs.hostPlatform.isx86_64 (
      with pkgs;
      [
        wineWow64Packages.unstableFull
        cpu-x
      ]
    );

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  # nh - nixos-rebuild wrapper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  # sudo-rs
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };
}
