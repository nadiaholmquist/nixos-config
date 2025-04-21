{
  imports = [
    ./fonts.nix
    ./app-setup.nix
    ./nh.nix
    ./rosetta-builder.nix
    ../common/builders.nix
    ../common/nix-settings.nix
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
