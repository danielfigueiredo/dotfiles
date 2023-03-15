{ config, pkgs, ... }: {
  # Have nix-darwin manage the Nix daemon
  services.nix-daemon.enable = true;

  nix.configureBuildUsers = true;

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
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    global = {
      brewfile = true;
    };
    brews = [
      "adr-tools"
      "asdf"
      "awscli"
      "ansible"
      "cocoapods"
      "cmake"
      "direnv"
      "docker-credential-helper-ecr"
      "gifski"
      "granted"
      "k6"
      "opa"
      "postgresql@14"
      "pyenv"
      "redis"
      "starship"
      "terraform"
      "terraformer"
      "terragrunt"
      "tflint"
      {
        name = "emacs-mac";
        args = [
          "with-starter"
          "with-native-comp"
          "with-mac-metal"
          "with-xwidgets"
        ];
      }
      # emacs-mac deps are explicitly listed so that others can be removed
      "m4"
      "autoconf"
      "automake"
      "bdw-gc"
      "gmp"
      "isl"
      "mpfr"
      "libmpc"
      "gcc"
      "gettext"
      "libtool"
      "libunistring"
      "libvterm"
      "pkg-config"
      "guile"
      "libidn2"
      "libnghttp2"
      "libtasn1"
      "nettle"
      "p11-kit"
      "unbound"
      "gnutls"
      "jansson"
      "libgccjit"
      "libxml2"
      "texinfo"
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
      "railwaycat/emacsmacport"
    ];
  };
}
