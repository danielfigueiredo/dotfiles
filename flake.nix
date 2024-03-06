{
  description = "Danrwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, flake-utils, home-manager }:
    let system = "aarch64-darwin";
    in {
      darwinConfigurations.dfigueiredo9a52 = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
          ({ ... }: {
            nixpkgs = { config = { allowUnfree = true; }; };
            users.users.dfigueiredo.home = "/Users/dfigueiredo";
            home-manager = {
              useGlobalPkgs = true;
              users.dfigueiredo = { imports = [ ./home.nix ]; };
            };
          })
        ];
      };
    };
}
