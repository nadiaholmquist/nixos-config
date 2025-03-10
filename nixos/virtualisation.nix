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

      programs.virt-manager.enable = lib.mkDefault true;

      environment.systemPackages = let
        arch = pkgs.hostPlatform.qemuArch;
        qemu-efi = pkgs.writeShellApplication {
          name = "qemu-system-${arch}-efi";
          runtimeInputs = [ pkgs.qemu_kvm ];
          text = ''
            cp ${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd "$PWD/"
            chmod 644 "$PWD/OVMF_VARS.fd"
            exec qemu-system-${arch} \
              -M q35 \
              -drive "if=pflash,readonly=on,format=raw,file=${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd" \
              -drive "if=pflash,format=raw,file=$PWD/OVMF_VARS.fd" \
              "$@"
          '';
        };
      in
      [
        pkgs.virtiofsd
        qemu-efi
      ];
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
