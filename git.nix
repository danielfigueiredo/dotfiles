{ config, ... }:

{
  xdg.configFile."git/wealthsimple.gitconfig".text = ''
    [user]
    email = dfigueiredo@wealthsimple.com
  '';
  programs.git = {
    enable = true;
    userName = "Dan Figueiredo";
    userEmail = "figdann@gmail.com";
    extraConfig = {
      github.user = "danielfigueiredo";
      fetch.prune = true;
      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = true;
      merge.conflictStyle = "diff3";
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
    includes = [{
      path = "${config.xdg.configHome}/git/wealthsimple.gitconfig";
      condition = "gitdir:~/code/ws/";
    }];
  };
}
