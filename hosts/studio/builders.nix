{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "narshe";
      systems = [ "x86_64-linux" "i686-linux" ];
      supportedFeatures = [ "kvm" "big-parallel" "nixos-test" "benchmark" ];
      sshUser = "nhp";
      protocol = "ssh-ng";
      maxJobs = 16;
    }
  ];
}
