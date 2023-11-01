
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      gnupg
  ];
  
  programs = {
   gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  services = {
    oauth2_proxy.enable = true; 
  };
}
