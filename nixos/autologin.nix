{ lib, config, ... }:

let 
 inherit (lib) mkOption mkIf types;
in {
  options = {
    dotfiles.autoLogin = mkOption {
      type = types.bool;
      description = "Configure the display manager for autologin.";
      default = false;
    };
  };

  config = mkIf config.dotfiles.autoLogin {
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "nhp";
      };
      sddm.autoLogin.relogin = true;
    };
  };
}
