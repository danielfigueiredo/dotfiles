{ lib, pkgs, config, ... }:

{
  programs.direnv.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = builtins.readFile ./zshrc + ''
      source "${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
      eval "$(${pkgs.mise}/bin/mise activate zsh)"

      # Force load session variables on shell start
      export __HM_SESS_VARS_SOURCED=""
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
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
    package = pkgs.emacs29-macport;
    extraPackages = (epkgs: [ epkgs.vterm ]);
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
  };

  programs.bat = { enable = true; };

  programs.starship = {
    enable = true;
    settings = { format = "$all"; };
  };
}
