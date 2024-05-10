{
lib,
pkgs,
config,
...
}:
{
let 
	cfg = config.custom.nix-colors;
in
	options.custom.nix-colors = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "Weather to enable Nix-colors. Default is false, because I couldn't think of a system, where I would not use it.";
		};

		colorSceme = lib.mkOption = {
			type = lib.types.str;
			default = "catppuccin-macchiato";
			description = "Dynamically set whichever colorsceme you can think of. But you need to configure it in once down here in order for nix-colors to know where to look.";
		};
	};

	nix-colors = lib.mkIf cfg.enable {
		lib.mkIf cfg.colorSceme = "catppuccin-macchiato" {
			colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
		};
		lib.mkIf cfg.colorSceme = "catppuccin-latte" {
			colorScheme = inputs.nix-colors.colorSchemes.catppuccin-latte;
		};
	};
}
