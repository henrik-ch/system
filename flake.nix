{
  description = "System Configurator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, anyrun, ... }:
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
        system.packages = [ anyrun.packages.${system}.anyrun ];
        modules = [
          ./host/book.nix
          ./os/base.nix
          ./os/base-time.nix
          ./os/base-programs.nix
          ./os/base-audio.nix
          # ./os/gui-gnome.nix
          ./os/gui-hyprland.nix
          ./usr/bzm3r.nix # we can add as many user modules as we need to here
        ];
      };
    };
  };
}
