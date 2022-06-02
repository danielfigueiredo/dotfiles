{ config, pkgs, ... }:

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
    nerdfonts
    jq
    ruby_3_0
    nodejs-16_x
  ];

  programs = {
    zsh = { 
      enable = true;
      shellAliases = {
        ll = "ls -la";
        idea="open -na /Applications/IntelliJ\\ IDEA.app --args";
        gcm="git checkout $(getGitDefaultBranch)";
        grm="git rebase $(getGitDefaultBranch)";
      };
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''	      
        # direnv configs
        export DIRENV_WARN_TIMEOUT=5m

        # get git repo default branch
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
