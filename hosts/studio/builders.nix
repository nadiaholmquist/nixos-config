{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    /*{
      hostName = "narshe.local";
      systems = [ "x86_64-linux" "i686-linux" ];
      supportedFeatures = [ "kvm" "big-parallel" "nixos-test" "benchmark" ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUY0bmdmM0NFR05HdnlDUGl2OVB1OWFSSUFwa0t4TXY0K3BaL2lMN1lHa1cgcm9vdEBuYXJzaGUK";
      sshUser = "nhp";
      protocol = "ssh-ng";
      maxJobs = 16;
    }*/
    {
      hostName = "build01";
      systems = [ "x86_64-linux" ];
      supportedFeatures = ["kvm" "big-parallel" "nixos-test" "benchmark"];
      sshUser = "ops";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUZIc2xMMUlUOFBEME91czVONmQrQ2lzclJLZjJybGROYWxGVmpOeTBHNDIgcm9vdEBidWlsZDAxCg==";
      protocol = "ssh-ng";
      maxJobs = 12;
    }
    {
      hostName = "build02";
      systems = [ "x86_64-linux" ];
      supportedFeatures = ["kvm" "big-parallel" "nixos-test" "benchmark"];
      sshUser = "ops";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxySFhvZVpzVHI4Y0tOT1ZSQ2FLOEpsbkFsOEh6dWk4R2Zuc2NZV3gyRjggcm9vdEBidWlsZDAyCg==";
      protocol = "ssh-ng";
      maxJobs = 12;
    }
  ];
}
