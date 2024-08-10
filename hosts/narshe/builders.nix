{ ... }:

{
  nix.settings.builders-use-substitutes = true;
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "studio.local";
      systems = [ "aarch64-darwin" ];
      supportedFeatures = ["apple-virt" "benchmark" "big-parallel" "nixos-test"];
      sshUser = "nhp";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJOYXVmdDNycHJvd2tpeE9YSFdvZnFaenAzVzNHcndoTXRseGw0WTM5RUggCg==";
      protocol = "ssh-ng";
      maxJobs = 10;
    }
  ];
}
