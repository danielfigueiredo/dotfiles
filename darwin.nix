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
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global = {
      brewfile = true;
      noLock = true;
    };
    brews = [ 
      "docker-credential-helper-ecr"
      "gifski"
      "postgresql"
    ];
    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
    ];
    casks = [
      "1password"
      "1password-cli"
      "docker"
      "discord"
      "firefox"
      "google-chrome"
      "grammarly"
      "intellij-idea"
      "pritunl"
      "slack"
      "spotify"
      "tuple"
      "vlc"
      "whatsapp"
      "zoom"
    ];
  };
}