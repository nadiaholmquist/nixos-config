{
  nix.gc.automatic = true;
  # NOT safe on macOS.
  nix.settings.auto-optimise-store = false;

  imports = [
    ./fonts.nix
    ./app-setup.nix
    ./nh.nix
    ./rosetta-builder.nix
    ../common/builders.nix
  ];

  users = {
    users.nhp = {
      name = "nhp";
      home = "/Users/nhp";
    };
  };

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;
}
