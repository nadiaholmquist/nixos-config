{ pkgs, lib, config, ... }:

{
  config = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    # Disable Home Manager's Applications symlink
    home.file."Applications/Home Manager Apps".enable = false;

    home.activation.addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] /*sh*/ ''
      echo "setting up ~/Applications/Home Manager Apps..." >&2
      nix_apps="$HOME/Applications/Home Manager Apps"
      $DRY_RUN_CMD rm -rf "$nix_apps"
      $DRY_RUN_CMD mkdir -p "$nix_apps"

      $DRY_RUN_CMD find ${apps}/Applications -maxdepth 1 -type l | while read app; do
        app_name="$(basename "$app")"
        mkdir "$nix_apps/$app_name"
        ln -s "$app/Contents" "$nix_apps/$app_name/Contents"
      done
    '';
  };
}
