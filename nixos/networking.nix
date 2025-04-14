{ pkgs, ... }:

{
  # Don't feel like dealing with it lol
  networking.firewall.enable = false;

  networking.networkmanager = {
    enable = true;
    settings = {
      # Respect DHCPv4 option 108
      # Doesn't seem to work setting it globally
      #ipv4.dhcp-ipv6-only-preferred = true;
    };
  };

  # IPv6 464XLAT support
  services.clatd.enable = true;

  # Use systemd-resolved for DNS caching and mDNS resolution
  services.resolved = {
    enable = true;
    llmnr = "false";
    extraConfig = ''
      MulticastDNS=resolve
    '';
  };

  # mDNS network publishing through avahi
  # (Consider trying to do this with resolved/systemd dns-sd?)
  services.avahi = {
    enable = true;
    openFirewall = true;
    publish = {
      enable = true;
      hinfo = true;
      workstation = true;
    };
    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
  };

}
