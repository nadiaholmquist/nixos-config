{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
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
