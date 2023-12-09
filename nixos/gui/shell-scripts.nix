{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [ (callPackage ./drvs/workon.nix { inherit pkgs; }) ];
}
