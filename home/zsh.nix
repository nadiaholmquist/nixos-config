{ config, pkgs, lib, ... }:

{
  options.dotfiles.zshPromptColor = with lib; mkOption {
    type = types.str;
    default = "green";
    description = "The shell prompt color.";
  };

  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      history.share = true;
      history.ignoreSpace = true;

      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];

      shellAliases = {
        # Use GNU coreutils's ls even on macOS
        # It lays out the file list a bit nicer and follows LS_COLORS
        "ls" = "${pkgs.coreutils}/bin/ls --color=auto";
      };

      initExtra = ''
        PROMPT='%F{${config.dotfiles.zshPromptColor}}%n@%m %B%1~%b %f%#%f '
        # Default wordchars without slash
        WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

        zstyle ':completion:*' rehash true
        # Case-insensitive completion
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}'
        # Completion uses dircolors
        zstyle ':completion:*' list-colors "''${(@s.:.)LS_COLORS}"
        bindkey '^[[1;5D' backward-word              # C-Left
        bindkey '^[[1;5C' forward-word               # C-Right
        bindkey "\e\x1B[C" forward-word
        bindkey "\e\x1B[D" backward-word

        test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
      '';
    };

    home.packages = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];

    programs.dircolors.enable = true;
  };
}
