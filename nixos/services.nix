{ ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # systemd-resolved
  services.resolved.enable = true;

  # mDNS network discovery
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.nssmdns6 = true;
}