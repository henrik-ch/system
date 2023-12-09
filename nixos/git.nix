{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gitFull
    gh
    reuse
    # gitkraken
  ];
}
