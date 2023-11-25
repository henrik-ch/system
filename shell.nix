{
        sources ? import ./npins,
        pkgs ? import sources.nixpkgs {}
}:

pkgs.mkShell {
        buildInputs = with pkgs; [
                nix
        ];
        shellHook = ''
                export nixpkgs=${sources.nixpkgs.outPath}
                export NIX_PATH=nixpkgs=${sources.nixpkgs.outPath}:nixos-config=/home/bzm3r/nixos-conf/default.nix
        '';
}
