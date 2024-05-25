{
lib,
config,
pkgs,
inputs,
...
}:
{
	imports =
	[
		./hardware-configuration.nix
	];

	custom.hyprland.enable = true;
	custom.persist.enable = true;
	
	system.stateVersion = "23.11";
}
