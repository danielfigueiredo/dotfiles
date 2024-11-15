{ config, pkgs, ... }: {
  # Have nix-darwin manage the Nix daemon
  services.nix-daemon.enable = true;

  ids.gids.nixbld = 30000;
  system.stateVersion = 5;

  nix.configureBuildUsers = true;

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
      "adr-tools"
      "awscli"
      "cocoapods"
      "docker-credential-helper-ecr"
      "gifski"
      "granted"
      "idb-companion"
      "lazygit"
      "lefthook"
      "opa"
      "pinentry-mac"
      "postgresql@14"
      "rustup"
    ];
    casks = [
      "1password-cli"
      "adobe-acrobat-reader"
      "airflow"
      "android-studio"
      "chromium"
      "dbeaver-community"
      "discord"
      "firefox"
      "flipper"
      "notion"
      "postman"
      "raycast"
      "spotify"
      "steam"
      "tuple"
      "vlc"
      "vienna"
      "visual-studio-code"
      "whatsapp"
      "zed"
    ];
    taps = [
      "common-fate/granted"
      "homebrew/bundle"
      "homebrew/services"
      "hashicorp/tap"
      "facebook/fb"
      "jesseduffield/lazygit"
    ];
  };
}
