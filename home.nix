{ config, pkgs, ... }:

let
  # prevents from bringin in > 2gb of fonts
  selectedNerdfonts = pkgs.nerdfonts.override {
    fonts = [ "FiraCode" "FiraMono" ];
  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dfigueiredo";
  home.homeDirectory = "/Users/dfigueiredo";

  # have nix-deamon managed by nix
  # nix.extraOptions = "experimental-features = nix-command flakes";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
  
  home.packages = with pkgs; [
    docker
    docker-compose
    git
    gh
    htop
    jq
    nodejs-16_x
    plantuml
    ruby_3_0
    selectedNerdfonts
    yarn
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    DIRENV_WARN_TIMEOUT = "5m";
  };

  programs = {
    zsh = { 
      enable = true;
      shellAliases = {
        ll = "ls -la";
        be="bundle exec";
        # Editor aliases, VS Code is added via home manager
        idea="open -na /Applications/IntelliJ\\ IDEA.app --args";
        # Git aliases
        gs="git status";
        gcm="git checkout $(getGitDefaultBranch)";
        grm="git rebase $(getGitDefaultBranch)";
        gcl="git checkout -";
        grhh="git reset --hard HEAD";
      };
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        function getGitDefaultBranch() {
          git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
        }
      '';
    };
    starship = {
      enable = true;
      settings = {
        format = "$all";
      };
    };
    direnv = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        yzhang.markdown-all-in-one
        bbenoist.nix
      ];
    };
  };
}
