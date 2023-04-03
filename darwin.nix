{ config, pkgs, ... }: {
  # Have nix-darwin manage the Nix daemon
  services.nix-daemon.enable = true;

  nix.configureBuildUsers = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      emacs-all-the-icons-fonts
      inter
    ];
  };

  # We use Nix flakes
  # this makes nix.conf be auto-generated
  nix.extraOptions = "experimental-features = nix-command flakes";

  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableCompletion = false;
    loginShellInit = ''
      eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
      source "''${ASDF_DIR}/asdf.sh"
      source "${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh"
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
    promptInit = "";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    global = { brewfile = true; };
    brews = [
      "adr-tools"
      "asdf"
      "awscli"
      "argocd"
      "cocoapods"
      "cmake"
      "docker-credential-helper-ecr"
      "gifski"
      "granted"
      "helm"
      "k6"
      "kubectl"
      "kustomize"
      "minikube"
      "opa"
      "postgresql@14"
      "pyenv"
      "redis"
      "terraform"
      "terraformer"
      "terragrunt"
      "tflint"
    ];
    casks = [
      "1password"
      "1password-cli"
      "android-studio"
      "adobe-acrobat-reader"
      "airflow"
      "dbeaver-community"
      "docker"
      "discord"
      "firefox"
      "google-chrome"
      "grammarly"
      "postman"
      "notion"
      "raycast"
      "slack"
      "spotify"
      "steam"
      "tuple"
      "vlc"
      "whatsapp"
      "zoom"
    ];
    taps = [
      "common-fate/granted"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/services"
      "hashicorp/tap"
    ];
  };
}
