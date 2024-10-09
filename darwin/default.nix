{ pkgs, ... }:

{
  services.nix-daemon.enable = true;
  nix.gc.automatic = true;
  # NOT safe on macOS.
  nix.settings.auto-optimise-store = false;

  imports = [
    ./fonts.nix
    ./app-setup.nix
  ];

  users = {
    users.nhp = {
      name = "nhp";
      home = "/Users/nhp";
    };
  };

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  environment.systemPackages = [
    # insert rant about how I understand the need for notarization but Apple's use of dark patterns to enforce it is bad here
    (pkgs.writeShellScriptBin "unquarantine" ''
      xattr -r -d com.apple.quarantine "$@"
    '')
  ];
}
