{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libreoffice
    vscode
    sile
    # vscodium <--- keep this for later, as it clashes with VS code
  ];
}
