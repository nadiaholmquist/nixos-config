{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "studio";
      systems = [ "aarch64-darwin" ];
      supportedFeatures = ["apple-virt" "benchmark" "big-parallel" "nixos-test"];
      sshUser = "nhp";
      protocol = "ssh-ng";
      maxJobs = 10;
    }
  ];
}
