{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "narshe.local";
      systems = [ "x86_64-linux" "i686-linux" ];
      supportedFeatures = [ "kvm" "big-parallel" "nixos-test" "benchmark" ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUY0bmdmM0NFR05HdnlDUGl2OVB1OWFSSUFwa0t4TXY0K3BaL2lMN1lHa1cgcm9vdEBuYXJzaGUK";
      sshUser = "nhp";
      protocol = "ssh-ng";
      maxJobs = 16;
    }
  ];
}
