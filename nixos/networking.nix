{ pkgs, lib, config, ... }:

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
  };

  # Publish services over mDNS using systemd's DNS-SD support
  environment.etc = {
    "systemd/dnssd/ssh.dnssd".text = ''
      [Service]
      Name=%H
      Port=22
      Type=_ssh._tcp
    '';
    "systemd/dnssd/sftp-ssh.dnssd".text = ''
      [Service]
      Name=%H
      Port=22
      Type=_sftp-ssh._tcp
    '';
  };

  # Applications expect to be able to resolve mDNS using Avahi
  services.avahi = {
    enable = true;
    openFirewall = true;
    publish.enable = false;
  };
}
