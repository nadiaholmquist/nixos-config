{ ... }:

{
  programs.neovim = {
    enable = true;
    #package = pkgs.pkgsUnstable.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true; # Needed for some plugins
    withPython3 = true;
    vimAlias = true;
    viAlias = true;
  };
}
