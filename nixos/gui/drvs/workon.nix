{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "workon";
  runtimeInputs = [ pkgs.vscode ];
  text = ''
    if test -z "$1"; then
      workspace="''${DEFAULT_WORKSPACE}"
    else
      workspace=/home/bzm3r/.vscode/workspaces/"$1".code-workspace
    fi

    code "$workspace"
  '';
}
