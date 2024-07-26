{ ... }:

{
  services.nix-daemon.enable = true;
  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;

  users = {
    users.nhp = {
      name = "nhp";
      home = "/Users/nhp";
    };
  };

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
}
