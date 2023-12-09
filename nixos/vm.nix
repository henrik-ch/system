{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    qemu
    libvirt

    distrobox
  ];
}
