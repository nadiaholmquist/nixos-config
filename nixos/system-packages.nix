{ lib, pkgs, ... }:

{
  environment.systemPackages = (with pkgs; [
    git
    file
    wget
    python3
    dig
    killall
    rsync

    gcc
    cmake

    alsa-utils

    stress-ng
  ]) ++ lib.optionals pkgs.hostPlatform.isx86_64 (with pkgs; [
    wineWow64Packages.full
    cpu-x
  ]);
}
