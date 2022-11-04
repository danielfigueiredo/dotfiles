{ config, pkgs, lib, ... }:

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
    cmake
    coreutils
    clj-kondo
    discount
    editorconfig-core-c
    emacs28Packages.evil-ediff
    fd
    fzf
    fontconfig
    gh
    gnuplot
    htop
    ispell
    jdk11
    jq
    ktlint
    nixfmt
    nodePackages.js-beautify
    nodePackages.stylelint
    nodejs
    plantuml
    poetry
    python39Full
    (ripgrep.override { withPCRE2 = true; })
    ruby_3_0
    selectedNerdfonts
    shellcheck
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
    DIRENV_WARN_TIMEOUT = "5m";
    ASDF_CONFIG_FILE = "${config.home.homeDirectory}/.config/asdfrc";
    ASDF_DEFAULT_TOOL_VERSIONS_FILENAME = "${config.home.homeDirectory}/.config/tool-versions";
    ASDF_DIR="/opt/homebrew/opt/asdf/libexec";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
  ];

  home.activation = {
    installDoom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      DOOM="${config.home.homeDirectory}/.emacs.d"
      if [ ! -dj $DOOM ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs.git $DOOM
        $DOOM/bin/doom install
      fi
    '';
  };

  home.file.".doom.d/init.el".source = ./.doom.d/init.el;
  home.file.".doom.d/packages.el".source = ./.doom.d/packages.el;
  home.file.".doom.d/config.el".source = ./.doom.d/config.el;
  home.file.".doom.d/custom.el".source = ./.doom.d/custom.el;
  xdg.configFile."shellcheckrc".source = ./shellcheckrc;
  xdg.configFile."asdfrc".source = ./asdfrc;
  xdg.configFile."tool-versions".source = ./tool-versions;
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs = {
    git = {
      enable = true;
      userName = "Dan Figueiredo";
      userEmail = "figdann@gmail.com";
      extraConfig = {
        fetch.prune = true;
        init.defaultBranch = "main";
        push.default = "current";
        pull.rebase = true;
      };
      ignores = [ ".#*" ".DS_Store" ".dir-locals.el" ".idea/" ".vscode/" ".direnv/" ];
    };
    home-manager = {
      enable = true;
    };
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
        gbpr="branchAndOpenPR";
        gurb="updateMainAndRebaseLastBranch";
      };
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        function getGitDefaultBranch() {
          git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
        }

        function wolfman() {
          pushd /Users/dfigueiredo/code/ws/wolfman > /dev/null

          set +e
          bin/wolfman $@
          set -e

          popd > /dev/null
        }

        function branchAndOpenPR() {
          set -e

          git checkout -b $1
          git add .
          git commit -m "$2"
          git push origin $1
          gh pr create --web
        }

        function updateMainAndRebaseLastBranch() {
          set -e

          git checkout $(getGitDefaultBranch)
          git pull
          git checkout -
          git rebase $(getGitDefaultBranch)
        }

        if [ -n "''${commands[fzf-share]}" ]; then
           source "$(fzf-share)/key-bindings.zsh"
           source "$(fzf-share)/completion.zsh"
        fi
        source "''${ASDF_DIR}/asdf.sh"
        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"
      '';
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
