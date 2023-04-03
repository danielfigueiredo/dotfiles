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
    aliases = {
      gs = "status";
      grhh = "reset --hard HEAD";
      gcm = "checkout $(getGitDefaultBranch)";
      grm = "rebase $(getGitDefaultBranch)";
      gcl = "checkout -";

    };
    ignores =
      [ ".#*" ".DS_Store" ".dir-locals.el" ".idea/" ".vscode/" ".direnv/" ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = builtins.readFile ./zshrc;
    shellAliases = {
      ll = "ls -la";
      be = "bundle exec";
      assume = "source assume";
      # Editor aliases, VS Code is added via home manager
      idea = "open -na /Applications/IntelliJ\\ IDEA.app --args";
      # Git custom aliases
      gcp = "addCommitPush";
      gbpr = "branchAndOpenPR";
      gurb = "updateMainAndRebaseLastBranch";
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs.overrideAttrs (original: {
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
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
    };
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
      bbenoist.nix
    ];
  };
}
