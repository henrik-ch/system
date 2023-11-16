{pkgs, ...}: {
  services = {
    # audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
      };
    };
    # how to handle alsa-plugins?
    xserver.libinput.enable = true;
  };

  programs.noisetorch.enable = true;

  security = {
    # for pulseaudio, pipewire, etc.
    rtkit.enable = true;
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-plugins
    easyeffects
    pavucontrol
    pamixer
  ];
}
