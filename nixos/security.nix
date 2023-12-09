{ pkgs, ... }: {
  # gnome keyring works through tty too
  security.pam.services.bzm3r.enableGnomeKeyring = true;

  services = { gnome.gnome-keyring.enable = true; };

  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };

  environment.systemPackages = with pkgs; [ gnupg libsecret lssecret ];
}
