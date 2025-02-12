{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkMerge
    mkDefault
    ;
  cfg = config.dotfiles.builders;

  builderVM = hostName: publicHostKey: {
    inherit hostName publicHostKey;

    systems = [
      "x86_64-linux"
      "i686-linux"
    ];
    supportedFeatures = [
      "kvm"
      "big-parallel"
      "nixos-test"
      "benchmark"
    ];
    sshUser = "ops";
    protocol = "ssh-ng";
    maxJobs = 12;
  };

in
{
  options.dotfiles.builders = {
    enable = mkEnableOption "Enable distributed builders";
    useBuilderVMs = mkOption {
      type = types.bool;
      default = true;
      description = "Use builder VMs";
    };

    useDesktop = mkEnableOption "Build on the desktop PC.";
    useMacStudio = mkEnableOption "Build on the Mac Studio";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nix.settings.builders-use-substitutes = mkDefault true;
      nix.distributedBuilds = mkDefault true;
    }

    (mkIf cfg.useBuilderVMs {
      nix.buildMachines = [
        (builderVM "build01" "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZIc2xMMUlUOFBEME91czVONmQrQ2lzclJLZjJybGROYWxGVmpOeTBHNDIgcm9vdEBidWlsZDAxCg==")
        (builderVM "build02" "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxySFhvZVpzVHI4Y0tOT1ZSQ2FLOEpsbkFsOEh6dWk4R2Zuc2NZV3gyRjggcm9vdEBidWlsZDAyCg==")
        (builderVM "build03" "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxNUEM1T1FUMnhtMFVRR2Zka0hPVkFjTTd2UTR4dVhhWGtmdFVyRUhpWUwgcm9vdEBidWlsZDAzCg==")
      ];
    })

    (mkIf cfg.useDesktop {
      nix.buildMachines = [
        {
          hostName = "narshe";
          supportedFeatures = [
            "kvm"
            "big-parallel"
            "nixos-test"
            "benchmark"
          ];
          sshUser = "nhp";
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUY0bmdmM0NFR05HdnlDUGl2OVB1OWFSSUFwa0t4TXY0K3BaL2lMN1lHa1cgcm9vdEBuYXJzaGUK";
          protocol = "ssh-ng";
          maxJobs = 16;
        }
      ];
    })

    (mkIf cfg.useMacStudio {
      nix.buildMachines = [
        {
          hostName = "studio.local";
          systems = [ "aarch64-darwin" ];
          supportedFeatures = [
            "apple-virt"
            "benchmark"
            "big-parallel"
            "nixos-test"
          ];
          sshUser = "nhp";
          publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJOYXVmdDNycHJvd2tpeE9YSFdvZnFaenAzVzNHcndoTXRseGw0WTM5RUggCg==";
          protocol = "ssh-ng";
          maxJobs = 10;
        }
      ];
    })
  ]);
}
