{
  description = "System Configurators";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        # which system's packages are we going to be using?
        # ans: the one we defined just above
        inherit system;
        config = { 
          allowUnfree = true; 
        };
      };

      lib = nixpkgs.lib;
    in     
      {
        nixosConfigurations = {
          book = lib.nixosSystem {
            # what underlying system is this going to be built on?
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.bzm3r = import ./home.nix;
             }
            ];
          };
        };
      };
}
