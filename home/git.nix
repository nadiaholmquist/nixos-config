{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Nadia Holmquist Pedersen";
    userEmail = "nadia@nhp.sh";

    lfs.enable = true;
    diff-so-fancy.enable = true;

    extraConfig =
      let
        diffTool = "nvimdiff";
        toolArgs = {
          prompt = false;
          keepBackup = false;
          keepTemporaries = false;
        };
      in
      {
        init.defaultBranch = "main";
        pull.rebase = true;
        url."git@github.com:".insteadOf = "github:";
        color.ui = "auto";
        fetch.recurseSubmoules = "on-demand";
        tag.sort = "version:refname";

        diff.algorithm = "histogram";

        diff.tool = diffTool;
        merge.tool = diffTool;

        difftool = toolArgs;
        mergetool = toolArgs // {
          nvimdiff.layout = "LOCAL,BASE,REMOTE / MERGED";
        };

        include.path = "config.local";
      };
  };
}
