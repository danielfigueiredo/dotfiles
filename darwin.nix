{ config, pkgs, ... }: {
  # Have nix-darwin manage the Nix daemon
  services.nix-daemon.enable = true;

  ids.gids.nixbld = 30000;
  system.stateVersion = 5;

  nix.configureBuildUsers = true;

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      emacs-all-the-icons-fonts
      inter
    ];
  };

  # We use Nix flakes
  # this makes nix.conf be auto-generated
  nix.extraOptions = "experimental-features = nix-command flakes";

  programs.zsh = { enable = true; };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };
    global = { brewfile = true; };
    brews = [
      "docker-credential-helper-ecr"
      "adr-tools"
      "awscli"
      "cocoapods"
      "gifski"
      "granted"
      "idb-companion"
      "lefthook"
      "opa"
      "postgresql@14"
    ];
    casks = [
      "1password-cli"
      "android-studio"
      "adobe-acrobat-reader"
      "airflow"
      "chromium"
      "dbeaver-community"
      "discord"
      "firefox"
      "flipper"
      "postman"
      "notion"
      "raycast"
      "spotify"
      "steam"
      "tuple"
      "vlc"
      "whatsapp"
      "zed"
    ];
    taps = [
      "common-fate/granted"
      "homebrew/bundle"
      "homebrew/services"
      "hashicorp/tap"
      "facebook/fb"
    ];
  };
}
