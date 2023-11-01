{
  description = "System Configurator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          ./os/base.nix
          ./os/base-time.nix
          ./os/base-programs.nix
          ./os/base-audio.nix
          ./gui-gnome.nix # for now, gnome
          ./usr/bzm3r.nix # we can add as many user modules as we need to here
        ];
      };
    };
  };
}
