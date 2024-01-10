{ config, pkgs, lib, ... }: {
  options = { quietBoot = lib.mkEnableOption "quietBoot"; };

  config = {
    # a bigger, default tty font
    console = with pkgs; {
      earlySetup = true;
      font = "${terminus_font}/share/consolefonts/ter-132n.psf.gz";
      packages = [ terminus_font ];
      keyMap = "us";
    };

    boot = lib.mkMerge [
      {
        initrd = { systemd.enable = true; } // config.machine.initrd;

        loader = {
          systemd-boot.enable = true;
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/efi";
          };
        };
        # explicitly set which device is to be used for storing hibernation/sleep
        # info if not ram
        resumeDevice = "/dev/disk/by-label/SWAP";
      }
      (lib.mkIf config.quietBoot {
        consoleLogLevel = 3;
        initrd.verbose = false;

        kernelParams = [
          # disable boot logo if any
          "logo.nologo"
          # disable verbose kernel
          "quiet"
          # disable systemd status messages
          "rd.systemd.show_status=auto"
          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"
          "console=tty2"
        ];
      })
      (lib.mkIf config.boot.plymouth.enable {
        kernelParams = [ "earlyprintk=efi,keep" ];
        plymouth = {
          theme = "spin";
          themePackages = [
            (pkgs.adi1090x-plymouth-themes.override {
              selected_themes = [ "spin" ];
            })
          ];
          font =
            "${pkgs.atkinson-hyperlegible}/share/fonts/opentype/AtkinsonHyperlegible-Regular.otf";
        };
      })
    ];

    powerManagement = lib.mkIf config.boot.plymouth.enable ({
      powerDownCommands = "${pkgs.plymouth}/bin/plymouth --show-splash";
      resumeCommands = "${pkgs.plymouth}/bin/plymouth --quit";
    });

    # for checking out which kernel modules are loaded
    environment.systemPackages = with pkgs; [ kmon ];

    #services.getty.autologinUser = config.userName;
  };
}
