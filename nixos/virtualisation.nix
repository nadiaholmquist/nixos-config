{ lib, pkgs, ... }:

{
  # libvirt
  virtualisation.libvirtd.enable = lib.mkDefault true;
  programs.virt-manager.enable = lib.mkDefault true;

  # Not Docker
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.dockerCompat = true;

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
