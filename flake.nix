{
  description = "System Configurator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
  let
    # find a nicer way to define this and pass it around
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    nixpkgs.pkgs = pkgs;

    nixosConfigurations = {
      book = nixpkgs.lib.nixosSystem {
        modules = [
          ./host-book.nix
          ./base
          ./gui
          ./bzm3r.nix # we can add as many user modules as we need to here
        ];
      };
    };
  };
}
