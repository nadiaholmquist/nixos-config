{ pkgs, lib, config, ... }:

let
  inherit (lib.attrsets) mapAttrs' nameValuePair;

  mkExtensions = exts: mapAttrs' (name: id:
    nameValuePair id {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
      installation_mode = "force_installed";
    }) exts;
in lib.mkIf config.dotfiles.enableHomeGuiApps {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      PasswordManagerEnabled = false; # I don't use the Firefox password manager

      ExtensionSettings = mkExtensions {
        ublock-origin = "uBlock0@raymondhill.net";
        bitwarden-password-manager = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        consent-o-matic = "gdpr@cavi.au.dk";
        youtube-auto-hd-fps = "avi6106@gmail.com";
        plasma-integration = "plasma-browser-integration@kde.org";
        sponsorblock = "sponsorBlocker@ajay.app";
      };

      Preferences = {
        "browser.tabs.closeWindowWithLastTab" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1; # Use KDE file picker
        "mousewheel.system_scroll_override.enabled" = 0; # More consistent scroll distance
      };
    };
  };
}
