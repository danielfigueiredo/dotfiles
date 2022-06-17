{
  description = "Danrwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, darwin, home-manager }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations.dfigueiredo177d = darwin.lib.darwinSystem {
        inherit system;

        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
          ({ ... }: {
            nixpkgs = {
              config = { allowUnfree = true; };
            };
            users.users.dfigueiredo.home = "/Users/dfigueiredo";
            home-manager = {
              useGlobalPkgs = true;
              users.dfigueiredo = {
                imports = [ ./home.nix ];
              };
            };
          })
        ];
      };
    };
}