{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    #package = pkgs.pkgsUnstable.neovim-unwrapped;
    defaultEditor = true;
    withNodeJs = true; # Needed for some plugins
    withPython3 = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      clang-tools
      nixd
      cmake-language-server
      tree-sitter
    ];
  };

  home.activation = {
    cloneNeovimConfig =
      lib.hm.dag.entryAfter [ "writeBoundary" ] # sh
        ''
          if [[ ! -d $HOME/.config/nvim ]]; then
            run ${lib.getExe pkgs.git} clone https://github.com/nadiaholmquist/neovim-config.git $HOME/.config/nvim
          fi
        '';
  };
}
