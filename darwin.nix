{ config, pkgs, ... }: {
  # Have nix-darwin manage the Nix daemon
  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;

  # We use Nix flakes
  # this makes nix.conf be auto-generated
  nix.extraOptions = "experimental-features = nix-command flakes";

  # Ensure nix-darwin configures ZSH with a Nix-aware PATH
  # this prevents the need to set NIX_PATH and other env vars
  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableCompletion = false;
    loginShellInit = ''
      eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';
    promptInit = "";
  };

  homebrew = {
    autoUpdate = true;
    brews = [
      "asdf"
      "awscli"
      "ansible"
      "direnv"
      "docker-credential-helper-ecr"
      "gifski"
      "postgresql"
      "pyenv"
      "terraform"
      "starship"
    ];
    casks = [
      "1password"
      "1password-cli"
      "dbeaver-community"
      "docker"
      "discord"
      "firefox"
      "google-chrome"
      "grammarly"
      "intellij-idea"
      "pritunl"
      "slack"
      "spotify"
      "steam"
      "tuple"
      "vlc"
      "whatsapp"
      "zoom"
    ];
    cleanup = "zap";
    enable = true;
    extraConfig = ''
      brew "emacs-mac", args: ["with-native-comp", "with-natural-title-bar"]
    '';
    global = {
      brewfile = true;
      noLock = true;
    };
    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "hashicorp/tap"
      "railwaycat/emacsmacport"
    ];
  };
}
