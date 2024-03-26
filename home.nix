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

  imports = [ ./zsh.nix ./git.nix ];

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    # python3
    # awscli2
    ansible
    argocd
    coreutils
    colima
    cmake
    docker
    docker-compose
    docker-buildx
    fd
    gh
    gitleaks
    kubernetes-helm
    ispell
    jq
    just
    k6
    kubectl
    kustomize
    k9s
    kotlin
    maven
    microplane
    minikube
    mise
    redis
    ripgrep
    selectedNerdfonts
    shellcheck
    tree
    terraform
    terragrunt
    tflint
    zsh-z

    # Doom deps
    coreutils
    dockfmt
    black
    python311Packages.pyflakes
    python311Packages.isort
    python311Packages.nose3
    python311Packages.pytest
    nodePackages.graphql-language-service-cli
    kotlin-language-server
    pipenv
    clang-tools_17
    ktlint
    nixfmt
    cargo
    rustc
    shfmt
    editorconfig-core-c
    fontconfig
    gnuplot
    pandoc
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient";
    DIRENV_WARN_TIMEOUT = "1m";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.config/emacs/bin"
  ];

  home.file = {
    ".config/doom/init.el".source = ./doom/init.el;
    ".config/doom/packages.el".source = ./doom/packages.el;
    ".config/doom/config.el".source = ./doom/config.el;
  };

  xdg.configFile = {
    "shellcheckrc".source = ./shellcheckrc;
    "mise/config.toml".source = ./mise/config.toml;
  };
}
