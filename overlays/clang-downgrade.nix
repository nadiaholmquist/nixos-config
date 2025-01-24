{
  targets = ["darwin"];
  overlay = final: prev: {
    minizip-ng = prev.minizip-ng.overrideAttrs {
      postPatch = ''
        substituteInPlace compat/crypt.h \
          --replace-fail register ""
      '';
    };
    sfml = prev.sfml.override { stdenv = final.clang18Stdenv; };
    dolphin-emu = prev.dolphin-emu.override { stdenv = final.clang18Stdenv; };
  };
}
