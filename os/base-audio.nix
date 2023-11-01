{ pkgs, ... }:

{
  hardware.pulseaudio.enable = false;

  services = {
    # audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # how to handle alsa-plugins?
    xserver.libinput.enable = true;
  };

  security = {
    # for pulseaudio, pipewire, etc.
    rtkit.enable = true;
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-plugins
    easyeffects
  ];
}
