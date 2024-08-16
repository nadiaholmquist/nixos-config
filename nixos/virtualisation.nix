{ lib, pkgs, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    dotfiles.enableVirtualisation = mkEnableOption "Enable virtualisation support.";
  };

  config = mkIf config.dotfiles.enableVirtualisation {
    # libvirt
    virtualisation.libvirtd.enable = lib.mkDefault true;
    virtualisation.libvirtd.qemu.swtpm.enable = lib.mkDefault true;
    virtualisation.libvirtd.qemu.ovmf.packages = with pkgs; [
      (OVMF.override {
        secureBoot = true;
        msVarsTemplate = true;
        tpmSupport = true;
      }).fd
    ];
    environment.systemPackages = [ pkgs.virtiofsd ];

    programs.virt-manager.enable = lib.mkDefault true;

    specialisation.vmware = mkIf (pkgs.system == "x86_64-linux") {
      configuration = { pkgs, ... }: {
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
        virtualisation.vmware.host.enable = true;
      };
    };

    # Not Docker
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerSocket.enable = true;
    virtualisation.podman.dockerCompat = true;
  };
}
