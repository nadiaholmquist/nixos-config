{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Sets LD_LIBRARY_PATH globally, breaks stuff
      #jack.enable = true;
      wireplumber.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    easyeffects
    qpwgraph
  ];
}
