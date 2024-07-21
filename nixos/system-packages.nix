{ pkgs, ... }:

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

    wineWow64Packages.full
    stress-ng
    cpu-x
  ];
}
