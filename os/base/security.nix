
{ ... }:

{
  programs = {
   gnupg = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  services = {
    oauth2_proxy.enable = true; 
  };
}
