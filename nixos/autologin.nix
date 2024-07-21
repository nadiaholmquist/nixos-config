{ lib, config, ... }:

{
  config = lib.mkIf config.dotfiles.autoLogin {
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "nhp";
      };
      sddm.autoLogin.relogin = true;
    };
  };
}
