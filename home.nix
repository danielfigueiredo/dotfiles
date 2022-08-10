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
    clj-kondo
    editorconfig-core-c
    fontconfig
    gnuplot
    nodejs
    nodePackages.js-beautify
    nodePackages.stylelint
    emacs28Packages.evil-ediff
    ktlint
    ispell
    cmake
    coreutils
    discount
    docker
    docker-compose
    gh
    fd
    htop
    jdk11
    jq
    nixfmt
    plantuml
    python39Full
    poetry
    (ripgrep.override { withPCRE2 = true; })
    ruby_3_0
    selectedNerdfonts
    shellcheck
  ];

  home.sessionVariables = {
    EDITOR = "vim";
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
        wolfman="~/code/ws/wolfman/exe/wolfman";
      };
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        function getGitDefaultBranch() {
          git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
        }

        source "''${ASDF_DIR}/asdf.sh"
        eval "$(starship init zsh)"

        # find a better spot to place these
        # cannot run asdf + direnv via nix as adsf requires to writeable path
        ASDF_CACHE="${config.home.homeDirectory}/.asdf_cache"
        if [[ ! -f $ASDF_CACHE ]]; then
          asdf plugin add direnv
          asdf install direnv latest
          asdf global direnv latest
          asdf plugin add nodejs
          echo "asdf_installed" > $ASDF_CACHE
        fi;
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
