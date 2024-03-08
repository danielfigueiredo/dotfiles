# Dependencies

Homebrew & Nix with Flakes

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

# Installation

```
mkdir -p ~/code/dan
git clone git@github.com:danielfigueiredo/dotfiles.git ~/.code/dan/dotfiles
cd ~/code/dan/dotfiles
nix build .#darwinConfiguration.<os-user>.system
./result/sw/bin/darwin-rebuild switch --flake .
```
