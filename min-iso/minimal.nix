{ pkgs, modulesPath, lib, ... }: {

  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages;

  environment.systemPackages = with pkgs; [
    (callPackage ./common-scripts.nix { })
    (callPackage ./specific-scripts.nix { })
    git
  ];

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959

  boot.supportedFilesystems =
    lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
}
