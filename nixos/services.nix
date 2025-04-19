{ pkgs, ... }:

{
  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # USB multiplexing daemon for iOS devices
    # makes tethering and file transfers and such work
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };
}
