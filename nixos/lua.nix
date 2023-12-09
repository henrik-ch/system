{ pkgs, ... }: { environment.systemPackages = with pkgs; [ lua luaformatter ]; }
