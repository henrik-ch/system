{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    helix # no vim or emacs allowed
  ];
}
