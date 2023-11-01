{ pkgs, ... }:

{
  services = {
    # login manager
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "sway";
          user = "bzm3r";
        };
      };
      default_session = {
        # see eisefunke/nixos/desktop for a more detailed set up of tuigreet
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    # necessary for swaylock to be able to verify credentials
    pam.services.swaylock = {};
  };
}
