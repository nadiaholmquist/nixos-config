{ pkgs, lib, config, ... }:

{
  environment.systemPackages = [
    pkgs.audacity
    pkgs.iterm2
  ];

  system.activationScripts.applications.text = lib.mkForce /*sh*/ ''
    # Set up applications.
    echo "setting up /Applications/Nix Apps..." >&2

    nix_apps='/Applications/Nix Apps'
    rm -rf "$nix_apps"
    mkdir -p "$nix_apps"

    find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read app; do
      appname="$(basename "$app")"
      mkdir "$nix_apps/$appname"
      ln -s "$app/Contents" "$nix_apps/$appname/Contents"
    done
  '';
}
