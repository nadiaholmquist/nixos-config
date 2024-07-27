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
      defaultKeymap = "emacs";
      history.share = true;
      history.ignoreSpace = true;
      shellAliases = {
        "ls" = "ls --color=auto";
      };
      initExtra = ''
        PROMPT='%F{${config.dotfiles.zshPromptColor}}%n@%m %B%1~%b %f%#%f '

        # Make slash not be considered part of a word
        #WORDCHARS=''${WORDCHARS/\/}
        autoload -U select-word-style
        select-word-style bash

        # Stolen from https://pm.bsc.es/gitlab/rarias/jungle/-/commit/3418e57907622bbfb35a3d93939324d97e4fd924
        # From Arch Linux and GRML
        bindkey "^R" history-incremental-pattern-search-backward
        bindkey "^S" history-incremental-pattern-search-forward

        # Auto rehash for new binaries
        zstyle ':completion:*' rehash true
        # show a nice menu with the matches
        #zstyle ':completion:*' menu yes select

        bindkey '\e[1~' beginning-of-line            # Home
        bindkey '\e[7~' beginning-of-line            # Home
        bindkey '\e[H'  beginning-of-line            # Home
        bindkey '\eOH'  beginning-of-line            # Home

        bindkey '\e[4~' end-of-line                  # End
        bindkey '\e[8~' end-of-line                  # End
        bindkey '\e[F ' end-of-line                  # End
        bindkey '\eOF'  end-of-line                  # End

        bindkey '^?'    backward-delete-char         # Backspace
        bindkey '\e[3~' delete-char                  # Del
        # bindkey '\e[3;5~' delete-char                # sometimes Del, sometimes C-Del
        bindkey '\e[2~' overwrite-mode               # Ins

        bindkey '^H'      backward-kill-word         # C-Backspace

        bindkey '5~'      kill-word                  # C-Del
        bindkey '^[[3;5~' kill-word                  # C-Del
        bindkey '^[[3^'   kill-word                  # C-Del

        bindkey "^[[1;5H" backward-kill-line         # C-Home
        bindkey "^[[7^"   backward-kill-line         # C-Home

        bindkey "^[[1;5F" kill-line                  # C-End
        bindkey "^[[8^"   kill-line                  # C-End

        bindkey '^[[1;5C' forward-word               # C-Right
        bindkey '^[0c'    forward-word               # C-Right
        bindkey '^[[5C'   forward-word               # C-Right

        bindkey '^[[1;5D' backward-word              # C-Left
        bindkey '^[0d'    backward-word              # C-Left
        bindkey '^[[5D'   backward-word              # C-Left

        # Option+Left/Right for macOS
        bindkey "\e\x1B[C" forward-word
        bindkey "\e\x1B[D" backward-word
      '';
    };

    home.packages = with pkgs; [
      zsh-completions
      nix-zsh-completions
    ];

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # Not in 24.05
    #programs.direnv.silent = true;
  };
}
