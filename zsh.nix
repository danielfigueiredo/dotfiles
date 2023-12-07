{ lib, pkgs, config, ... }:

{
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "Dan Figueiredo";
    userEmail = "figdann@gmail.com";
    extraConfig = {
      fetch.prune = true;
      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = true;
    };
    ignores =
      [ ".#*" ".DS_Store" ".dir-locals.el" ".idea/" ".vscode/" ".direnv/" ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = builtins.readFile ./zshrc + ''
      source "${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(rtx activate zsh)"
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
    shellAliases = {
      ll = "ls -la";
      be = "bundle exec";
      assume = "source assume";
      k = "kubectl";
      # Git custom aliases
      gs = "git status";
      gp = "git pull";
      grhh = "git reset --hard HEAD";
      gcm = "checkoutDefaultBranch";
      grm = "updateMainAndRebaseLastBranch";
      gcl = "git checkout -";
      gcp = "addCommitPush";
      gbpr = "branchAndOpenPR";
      gcrb = "checkoutRemoteBranch";
      gcws = "cloneWSRepository";
      gspp = "stashPullPop";
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.overrideAttrs (original: {
      patches = (original.patches or [ ]) ++ [
        ./emacs/patches/fix-window-role.patch
        ./emacs/patches/increase-block-alignment.patch
        ./emacs/patches/system-appearance.patch
      ];
    });
    extraPackages = (epkgs: [ epkgs.vterm ]);
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
  };

  programs.bat = {
    enable = true;
    config = { theme = "gruvbox-light"; };
  };

  programs.starship = {
    enable = true;
    settings = { format = "$all"; };
  };
}
