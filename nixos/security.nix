{ pkgs, config, ... }: {
  # gnome keyring works through tty too
  services = { gnome.gnome-keyring.enable = true; };

  programs.gnupg = {
    agent = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ gnupg libsecret lssecret ];
}
