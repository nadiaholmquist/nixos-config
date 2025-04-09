{
  lib,
  callPackage,
  linuxPackagesFor,
  kernelPatches,
  ...
}:

let
  modDirVersion = "6.14.0";
  linuxPkg =
    { fetchFromGitLab, buildLinux, ... }@args:
    buildLinux (
      args
      // {
        version = "${modDirVersion}-rockchip-3588";

        # https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux
        src = fetchFromGitLab {
          domain = "gitlab.collabora.com";
          owner = "hardware-enablement";
          repo = "rockchip-3588/linux";
          rev = "ccc5f4690752058e2954e287d7704599f1f8122b";
          hash = "";
        };

        inherit modDirVersion;
        kernelPatches = [ ] ++ kernelPatches;

        extraMeta.branch = "rk3588";
      }
      // (args.argsOverride or { })
    );

in
lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
