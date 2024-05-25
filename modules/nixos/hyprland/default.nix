{
	lib,
	config,
	inputs,
	pkgs,
	...
}:

let
	cfg = config.custom.hyprland;
in
{
	options.custom.hyprland = {
		enable = lib.mkEnableOption "Hyprland and my configuration for it.";
	};

	config = lib.mkIf cfg.enable {
		programs.hyprland.enable = true;

		# Home Manager for Hyprland
		wayland.windowManager.hyprland = {
			enable = true;
			settings = {
				gaps_in = "2";
				# colors, dependent on nix-colors
				"col.active_border" = "rgba(${config.colorScheme.colors.base0E}ff) rgba(${config.colorScheme.colors.base09}ff) 60deg";
				"col.inactive_border" = "rgba(${config.colorScheme.colors.base00}ff)";
				"col.nogroup_border" = "rgba(${config.colorScheme.colors.base00}ff) rgba(${config.colorScheme.colors.base04}ff)";
				"col.nogoup_border_active" = "rgba(${config.colorScheme.colors.base0E}ff) rgba(${config.colorScheme.colors.base09}ff) 60deg";

				# other General
				
				# Input
				kb_layout = "de";
				numlock_by_default = "true";
				repeat_rate = "35";
				accel_profile = "flat";

				# OpenGL
				force_introspection = "1";
				
				# Binds
				"$mod" = "SUPER";
				bind = [
					"$mainMod, Q, exec, kitty"
					"$mainMod, C, killactive, "
					"$mainMod_SHIFT, M, exit,"
					"$mainMod, V, togglefloating, "
					"$mainMod, R, exec, rofi -show drun -show-icons"
					"$mainMod, J, togglesplit, # dwindle"
				];
			};
		};

		# Persistence
		custom.persist.home = {
			files = [ "/home/andi/.config/hypr/hyprland.conf" ];
		};

		# Packages
		environment.systemPackages = [
			pkgs.kitty
			pkgs.dolphin
			pkgs.mako
			pkgs.lf
			pkgs.libnotify
			pkgs.rofi-wayland
			pkgs.swww
			pkgs.hyprpaper
		];
	};
}

