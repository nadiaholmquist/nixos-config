{
  pkgs,
  lib,
  ...
}:

{
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    corefonts
    vistafonts
    inter

    fira
    # Some editors do not like variable TTF fonts, so use the regular one
    (fira-code.override { useVariableFont = false; })
    nerd-fonts.fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    cascadia-code
  ];

  fonts.fontconfig = {
    subpixel.rgba = lib.mkDefault "rgb";
    defaultFonts.monospace = [ "Fira Mono" ];
    defaultFonts.sansSerif = [ "Inter" ];
    defaultFonts.serif = [ "Times New Roman" ];
  };

  environment.sessionVariables = {
    # Enables stem darkening on fonts
    # This gives them a bolder appearance that I find more legible.
    # I don't think this can be done with fontconfig so an environment variable is the best we've got
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
  };
}
