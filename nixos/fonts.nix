{ pkgs, inputs, ...}:

{
  fonts.packages = with pkgs; let
    apple = inputs.apple-fonts.packages.${pkgs.system};
  in [
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk
    corefonts
    vistafonts
    inter

    fira
    # Some editors do not like variable TTF fonts, so use the regular one
    (fira-code.override { useVariableFont = false; })
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    apple.sf-pro
    apple.sf-compact
    apple.ny
  ];

  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts.monospace = ["Fira Mono"];
    # Need to figure out how to make this use SF Pro Display at and above 20pt. Use default for now.
    #defaultFonts.sansSerif = ["SF Pro Text"];
    defaultFonts.sansSerif = ["Inter"];
    defaultFonts.serif = ["Times New Roman"];
  };

  environment.sessionVariables = {
    # Enables stem darkening on fonts
    # This gives them a bolder appearance that I find more legible.
    # I don't think this can be done with fontconfig so an environment variable is the best we've got
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
  };
}
