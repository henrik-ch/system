inputs:
with (import ./fmt.nix inputs);
with (import ./useful.nix inputs);
with (import ./lib_imports.nix inputs);
with (import ./spacers.nix inputs);
with builtins;
let
  vivid_palette = {
      black = "#000000";
      white = "#ffffff";
      red = "#d20f39";
      pink = "#ff6dd8";
      silver = "#6c6f85";
      slate = "#313131";
      green = "#40a02b";
      lime = "#a1d540";
      teal = "#179299";
      yellow = "#dfc51d";
      sepia = "#d9af3b";
      peach = "#fe640b";
      flamingo = "#dd7878";
      sky = "#04a5e5";
      mauve = "#a87ae5";
      sapphire = "#209fb5";
  };
  colorStylor = fg: bg:
    if fg == bg then
      {}
    else
      {
        "${fg}${capitalize bg}" = createStylor fg bg;
      };
  color_stylors = concatMapAttrs
    (fg: fv:
      concatMapAttrs
        (bg: bv: colorStylor fg bg)
        vivid_palette
    )
    vivid_palette;
in
{
  inherit vivid_palette;
} // color_stylors
