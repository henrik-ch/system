{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zip
    xz
    unzip

    p7zip
    zstd
  ];
}
