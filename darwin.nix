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

  programs.zsh = { enable = true; };

  system = {
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        static-only = true;
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };
    global = { brewfile = true; };
    brews = [
      "adr-tools"
      "cocoapods"
      "gifski"
      "granted"
      "lefthook"
      "opa"
      "postgresql@14"
    ];
    casks = [
      "1password"
      "1password-cli"
      "android-studio"
      "adobe-acrobat-reader"
      "airflow"
      "chromium"
      "dbeaver-community"
      "discord"
      "firefox"
      "flipper"
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
