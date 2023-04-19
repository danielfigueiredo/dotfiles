# Dependencies

Homebrew

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Nix

```
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

# Installation

```
git clone git@github.com:danielfigueiredo/dotfiles.git
cd dotfiles
darwin-rebuild switch --flake .
```
