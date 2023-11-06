{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };

  # it seems that programs to provide basic functionality
  # for hyprland must be installed at a user level
  # otherwise we would have to use sudo 
}
