{
  lib,
  callPackage,
  linuxPackagesFor,
  kernelPatches,
  ...
}:

let
  modDirVersion = "6.13.0";
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
          rev = "d45f955d263ed91e45808aa82b9379a4109ad713";
          hash = "sha256-nenI5pPfRZRpK83QQCJ6U28V+EcQBEouz0Hv4zFLkxk";
        };

        inherit modDirVersion;
        kernelPatches = [ ] ++ kernelPatches;

        extraMeta.branch = "rk3588";
      }
      // (args.argsOverride or { })
    );

in
lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
