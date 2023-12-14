{ ... }: {
  programs.zsh = {
    enable = true;
    histSize = 1000;
    histFile = "~bzm3r/.histfile";
    enableCompletion = true;
    enableGlobalCompInit = true;
    syntaxHighlighting = { highlighters = [ "main" ]; };
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
      async = true;
      highlightStyle = "fg=3";
    };
    enableLsColors = true;
  };
}
