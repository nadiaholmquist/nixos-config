{ pkgs, ... }:

{
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  environment.etc = {
    # High-resolution scrolling on Linux is too janky to use because of the weird deadzone behavior that I can't find a way to disable.
    # So just disable it entirely for now :(
    "libinput/local-overrides.quirks".text = ''
      [Logitech MX Master 3]
      MatchVendor=0x46D
      MatchProduct=0x4082
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;

      # MX Master 3 has a different PID on bluetooth
      [Logitech MX Master 3]
      MatchVendor=0x46D
      MatchProduct=0xB023
      AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES
    '';
  };
}
