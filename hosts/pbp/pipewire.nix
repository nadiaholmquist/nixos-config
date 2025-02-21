{ pkgs, ... }:

# Mostly stolen from Asahi Linux
# obviously can't do the fancy speaker measuring stuff so yeah this probably doesn't really work so I'm just gonna leave it here and not include it

{
  services.pipewire = {
    extraLv2Packages = [
      pkgs.bankstown-lv2
      pkgs.lsp-plugins
    ];

    extraConfig.pipewire."99-filter-chain" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "PineBook Pro Speakers";
            "media.name" = "PineBook Pro Speakers";
            "filter.graph" = {
              "nodes" = [
                {
                  "type" = "lv2";
                  "plugin" = "https://chadmed.au/bankstown";
                  "name" = "bassex";
                  "control" = {
                    "bypass" = 0;
                    "amt" = 1.3;
                    "sat_second" = 1.3;
                    "sat_third" = 1.85;
                    "blend" = 1.0;
                    "ceil" = 200.0;
                    "floor" = 20.0;
                    #"final_hp" = 100.0;
                  };
                }
                {
                  "type" = "lv2";
                  "plugin" = "http://lsp-plug.in/plugins/lv2/loud_comp_mono";
                  "name" = "ell";
                  "control" = {
                    "enabled" = 1;
                    "input" = 1.0;
                    "fft" = 2;
                  };
                }
                {
                  "type" = "lv2";
                  "plugin" = "http://lsp-plug.in/plugins/lv2/loud_comp_mono";
                  "name" = "elr";
                  "control" = {
                    "enabled" = 1;
                    "input" = 1.0;
                    "fft" = 2;
                  };
                }
                /*{
                  "type" = "lv2";
                  "plugin" = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo";
                  "name" = "woofer_bp";
                  "control" = {
                      "mode" = 0;
                      "ce_0" = 1;
                      "sla_0" = 5.0;
                      "cr_0" = 1.75;
                      "al_0" = 0.725;
                      "at_0" = 1.0;
                      "rt_0" = 100;
                      "kn_0" = 0.125;
                      "cbe_1" = 1;
                      "sf_1" = 200.0;
                      "ce_1" = 0;
                      "cbe_2" = 0;
                      "ce_2" = 0;
                      "cbe_3" = 0;
                      "ce_3" = 0;
                      "cbe_4" = 0;
                      "ce_4" = 0;
                      "cbe_5" = 0;
                      "ce_5" = 0;
                      "cbe_6" = 0;
                      "ce_6" = 0;
                  };
              }
              {
                  "type" = "lv2";
                  "plugin" = "http://lsp-plug.in/plugins/lv2/compressor_stereo";
                  "name" = "woofer_lim";
                  "control" = {
                      "sla" = 5.0;
                      "al" = 1.0;
                      "at" = 1.0;
                      "rt" = 100.0;
                      "cr" = 15.0;
                      "kn" = 0.5;
                  };
                }*/
              ];
              "links" = [
                {"output" = "bassex:out_l"; "input" = "ell:in";}
                {"output" = "bassex:out_r"; "input" = "elr:in";}
                /*{"output" = "ell:out"; "input" = "woofer_bp:in_l";}
                {"output" = "elr:out"; "input" = "woofer_bp:in_r";}
                {"output" = "woofer_bp:out_l"; "input" = "woofer_lim:in_l";}
                {"output" = "woofer_bp:out_r"; "input" = "woofer_lim:in_r";}*/
              ];
              "inputs" = [
                "bassex:in_l"
                "bassex:in_r"
              ];
              "outputs" = [
                #"woofer_lim:out_l"
                #"woofer_lim:out_r"
                "ell:out"
                "elr:out"
              ];
            };
            "capture.props" = {
              "node.name" = "audio_effect.pbp-speakers";
              "media.class" = "Audio/Sink";
              "audio.channels" = "2";
              "audio.position" = ["FL" "FR"];
              "audio.allowed-rates" = [48000 44100];
              "device.api" = "dsp";
              "node.virtual" = "false";
              "priority.session" = 850;
              "state.default-channel-volume" = 0.343;
              "device.icon-name" = "audio-speakers";
            };
            "playback.props" = {
              "node.name" = "effect_output.pbp-speakers";
              "target.object" = "alsa_output.platform-es8316-sound.stereo-fallback";
              "node.passive" = "true";
              "audio.channels" = "2";
              "audio.allowed-rates" = [48000 44100];
              "audio.position" = ["FL" "FR"];
            };
          };
        }
      ];
    };
  };
}
