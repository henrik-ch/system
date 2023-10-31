# thanks to: git.eisfunke.com/config/

{ pkgs, lib, inputs }:

{
  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.serlf.rev;

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  programs = {
    # a better traceroute
    mtr.enable = true;

    # enable git globally, config is at home level
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

  # use systemd on initrd
  boot.initrd.systemd.enable = true;
  # enable fwupd daemon for finding any missing firmware
  services.fwupd.enable = true;

  # not really relevant (single user machine)
  security.sudo.extraConfig =
    '' Defaults lecture = never '';
}