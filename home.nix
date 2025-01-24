{ pkgs, ... }:

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

  imports = [ ./zsh.nix ./git.nix ];

  home.packages = with pkgs; [
    ansible
    argocd
    coreutils
    colima
    cmake
    delta
    docker
    docker-compose
    docker-buildx
    fd
    gh
    gnupg1
    gitleaks
    jq
    jujutsu
    just
    kubernetes-helm
    k6
    kubectl
    kustomize
    k9s
    kind
    kotlin
    maven
    microplane
    mise
    nixd
    rainfrog
    redis
    ripgrep
    shellcheck
    tree
    terraform
    terragrunt
    yq
    zsh-z
  ];

  home.sessionVariables = {
    DIRENV_WARN_TIMEOUT = "1m";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  home.file = {
    ".config/zed/settings.json".source = ./zed/settings.json;
    ".config/zed/keymap.json".source = ./zed/keymap.json;
    ".config/zed/tasks.json".source = ./zed/tasks.json;
    ".config/lazygit/config.yml".source = ./lazygit/config.yml;
  };

  xdg.configFile = {
    "shellcheckrc".source = ./shellcheckrc;
    "mise/config.toml".source = ./mise/config.toml;
  };
}
