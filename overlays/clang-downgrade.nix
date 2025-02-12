{
  targets = [ "darwin" ];
  overlay = final: prev: {
    sfml = prev.sfml.override { stdenv = final.clang18Stdenv; };
    dolphin-emu = prev.dolphin-emu.override { stdenv = final.clang18Stdenv; };
  };
}
