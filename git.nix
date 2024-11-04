{ config, ... }:

{
  xdg.configFile."git/wealthsimple.gitconfig".text = ''
    [user]
    email = dfigueiredo@wealthsimple.com
    signingkey = 5E4068D8B80EB62E
  '';
  xdg.configFile."git/personal.gitconfig".text = ''
    [user]
    signingkey = EB0D5DEF3F2B8AAC
  '';
  programs.git = {
    enable = true;
    userName = "Daniel Figueiredo";
    userEmail = "figdann@gmail.com";
    extraConfig = {
      github.user = "danielfigueiredo";
      fetch.prune = true;
      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = true;
      merge.conflictStyle = "diff3";
      commit.gpgSign = true;
      url = {
        "git@github.com:wealthsimple" = {
          insteadOf = "https://github.com/wealthsimple";
        };
      };
    };
    ignores = [
      ".#*"
      ".DS_Store"
      ".dir-locals.el"
      ".direnv/"
      ".idea/"
      ".vscode/"
      ".clj-kondo/"
      ".lsp/"
      "*.iml"
    ];
    includes = [
        {
            path = "${config.xdg.configHome}/git/wealthsimple.gitconfig";
            condition = "gitdir:~/code/ws/";
        }
        {
            path = "${config.xdg.configHome}/git/personal.gitconfig";
            condition = "!gitdir:~/code/ws/";
        }
    ];
  };
}
