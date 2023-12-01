{ pkgs, ... }: {
  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nil
    nixpkgs-fmt
    nix-init
  ];
}
