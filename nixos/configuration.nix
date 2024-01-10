{ lib, ... }: {
  imports = [
    ./admin.nix
    ./aliases.nix
    ./audio.nix
    ./basics.nix
    ./boot.nix
    ./xdg.nix
    ./dev.nix
    ./git.nix
    ./lua.nix
    ./nix.nix
    ./productivity.nix
    ./security.nix
    ./userspace.nix
    ./vm.nix
    ./xdg.nix
    ./zip.nix
    ./zsh.nix
  ] ++ [ ./gui ./starship ];

  config = {
    nix.settings = {
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # enable some of the experimental commands for now
      experimental-features = [ "nix-command" ];
    };

    hardware.opengl.enable = true;

    services = {
      # hardware scanner + firmware recommender
      fwupd.enable = true;
      udisks2.enable = true;
    };

    boot.plymouth.enable = lib.mkDefault false;

    # original condition: config.machine.label == "d"
    specialisation = lib.mkIf (false) {
      withPlymouth.configuration = {
        boot.plymouth.enable = lib.mkForce true;
        quietBoot = lib.mkForce true;
      };
    };

    system.stateVersion =
      "24.05"; # TODO: properly understand why this should not be changed in general.
  };
}
