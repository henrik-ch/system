{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gitFull
    gh
    # gitkraken
  ];
}