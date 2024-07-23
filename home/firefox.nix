{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      PasswordManagerEnabled = false; # I don't use the Firefox password manager
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = { # Bitwarden
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "gdpr@cavi.au.dk" = { # Consent-o-Matic
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi";
          installation_mode = "force_installed";
        };
        "avi6106@gmail.com" = { # YouTube Auto HD + FPS
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-auto-hd-fps/latest.xpi";
          installation_mode = "force_installed";
        };
        "plasma-browser-integration@kde.org" = { # KDE integration
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = {
        "browser.tabs.closeWindowWithLastTab" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1; # Use KDE file picker
        "mousewheel.system_scroll_override.enabled" = 0; # More consistent scroll distance
      };
    };
  };
}
