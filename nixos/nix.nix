{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ nil nixfmt nix-init ];
}
