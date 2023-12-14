{ pkgs, config, ... }: {
  # gnome keyring works through tty too
  #services = { gnome.gnome-keyring.enable = true; };
  security.pam.services.${config.singleUser}.enableGnomeKeyring = true;

  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };

  environment.systemPackages = with pkgs; [ gnupg libsecret lssecret ];
}
