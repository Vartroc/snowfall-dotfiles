

{ config, lib, pkgs, inputs, ... }:
let
	options.options
{

        # Use the GRUB boot loader.
        boot.loader.grub.enable = true;
        boot.loader.grub.devices = [ "nodev" ];
        boot.loader.grub.efiInstallAsRemovable = true;
        boot.loader.grub.efiSupport = true;
        boot.loader.grub.useOSProber = true;

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        
        time.timeZone = "Europe/Berlin";
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;

        i18n.defaultLocale = "de_DE.UTF-8";
        console = {
                font = "Lat2-Terminus16";
                keyMap = "de";
        };

        environment.systemPackages = with pkgs; [
		
		# Essentials
                neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
                wget
		Firefox
		git
		zip
        ];
}

