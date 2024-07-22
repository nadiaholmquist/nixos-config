{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    file
    wget
    python3
    dig
    killall
    rsync

    gcc
    cmake

    stress-ng
  ] ++ lib.optionals pkgs.hostPlatform.isx86_64 [
    wineWow64Packages.full
    cpu-x
  ];
}
