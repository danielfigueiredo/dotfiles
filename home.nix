{ config, pkgs, lib, ... }:

let
  # prevents from bringin in > 2gb of fonts
  selectedNerdfonts =
    pkgs.nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; };
in {
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

  imports = [ ./zsh.nix ];

  home.packages = with pkgs; [
    coreutils
    clj-kondo
    discount
    editorconfig-core-c
    fd
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
    (ripgrep.override { withPCRE2 = true; })
    selectedNerdfonts
    shellcheck
    zsh-z

    # doom deps
    coreutils
    discount
    editorconfig-core-c
    fontconfig
    gnuplot
    pandoc
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];

  home.sessionVariables = {
    EDITOR = "emacs";
    DIRENV_WARN_TIMEOUT = "5m";
    ASDF_CONFIG_FILE = "${config.home.homeDirectory}/.config/asdfrc";
    ASDF_DEFAULT_TOOL_VERSIONS_FILENAME =
      "${config.home.homeDirectory}/.config/tool-versions";
    ASDF_DIR = "/opt/homebrew/opt/asdf/libexec";
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

  home.file = {
    ".doom.d/init.el".source = ./.doom.d/init.el;
    ".doom.d/packages.el".source = ./.doom.d/packages.el;
    ".doom.d/config.el".source = ./.doom.d/config.el;
    ".emacs.d/profiles.el".source = ./emacs.d/profiles.el;
  };

  xdg.configFile = {
    "shellcheckrc".source = ./shellcheckrc;
    "asdfrc".source = ./asdfrc;
    "tool-versions".source = ./tool-versions;
  };
}
