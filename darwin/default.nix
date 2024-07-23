{ ... }:

{
  services.nix-daemon.enable = true;

  users = {
    users.nhp = {
      name = "nhp";
      home = "/Users/nhp";
    };
  };

  programs.zsh.enable = true;
}
