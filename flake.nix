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
      l = nixpkgs.lib.nixosSystem {
        modules = [
          ./host-l.nix          
          ./core
          ./gui-common.nix
          ./gui-sway.nix
          #./gui-hyprland.nix
        ];
      };
      d = nixpkgs.lib.nixosSystem {
        modules = [
          ./host-d.nix
          ./core
          ./gui-common.nix
          ./gui-sway.nix
          #./gui-hyprland.nix
        ];
      };
    };
  };
}
