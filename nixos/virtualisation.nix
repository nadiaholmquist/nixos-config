{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkMerge mkIf mkEnableOption;
in
{
  options = {
    dotfiles.enableVirtualisation = mkEnableOption "Enable virtualisation support.";
    dotfiles.enableVMWare = mkEnableOption "Enable VMWare Workstation and required specialisation.";
  };

  config = mkMerge [
    # Podman is installed unconditionally
    {
      virtualisation.podman.enable = true;
      virtualisation.podman.dockerSocket.enable = true;
      virtualisation.podman.dockerCompat = true;
    }

    (mkIf config.dotfiles.enableVirtualisation {
      # libvirt
      virtualisation.libvirtd.enable = lib.mkDefault true;
      virtualisation.libvirtd.qemu.swtpm.enable = lib.mkDefault true;
      virtualisation.libvirtd.qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
      environment.systemPackages = [ pkgs.virtiofsd ];

      programs.virt-manager.enable = lib.mkDefault true;
    })

    (mkIf config.dotfiles.enableVMWare {
      specialisation.vmware = mkIf (pkgs.system == "x86_64-linux") {
        configuration =
          { pkgs, ... }:
          {
            boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
            virtualisation.vmware.host.enable = true;
            virtualisation.vmware.host.package = pkgs.vmware-workstation.override {
              enableMacOSGuests = true;
            };
          };
      };
    })
  ];
}
