{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ discord element-desktop ];

  # IRC
  services = { convos.enable = true; };
}
