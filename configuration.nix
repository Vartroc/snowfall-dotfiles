

{ config, lib, pkgs, inputs, ... }:

{
        imports =
        [ # Include the results of the hardware scan.
          ./hardware-configuration.nix
        ];

        # Use the systemd-boot GRUB boot loader.
        boot.loader.grub.enable = true;
        boot.loader.grub.devices = [ "nodev" ];
        boot.loader.grub.efiInstallAsRemovable = true;
        boot.loader.grub.efiSupport = true;
        boot.loader.grub.useOSProber = true;    
        
        time.timeZone = "Europe/Berlin";
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;

        users.users."andi" = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        };

	programs.steam.enable = true;

        i18n.defaultLocale = "de_DE.UTF-8";
        console = {
                font = "Lat2-Terminus16";
                keyMap = "de";
        };

        programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

        xdg.portal.enable = true;
        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	
	environment.sessionVariables = {
		WLR_No_HARDWARE_CURSERS = "1";
		NIXOS_OZONE_WL = "1";
	};

	hardware = {
		opengl.enable = true;
	};

        sound.enable = true;
        security.rtkit.enable = true;
        services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
        };


        environment.systemPackages = with pkgs; [
		
		# Essentials
                home-manager
                neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
                wget
                waybar
                (waybar.overrideAttrs (oldAttrs: {
                        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                        })
                )
                networkmanagerapplet
                hyprpaper
		swww
		mako
		libnotify
		wezterm
                kitty
                rofi-wayland
		wofi
		git
		grim
		slurp
		wf-recorder
		mpv
		zoxide
                zip

		# Apps
                firefox
		qutebrowser
                discord
                whatsapp-for-linux
                element-desktop

		# Gaming
                prismlauncher
                lutris
                wine
                winetricks
                bottles

		# Missalaneous
                pinta
                dolphin
                libreoffice
        ];
        

        fileSystems."/persist".neededForBoot = true;
        environment.persistence."/persist/system" = {
                hideMounts = true;
                directories = [
                       "/etc/nixos"
	#		"/home/andi/.mozilla"
	#		"/home/andi/.steam"
                ];
	#	files = [
	#		"/home/andi/.config/hypr/hyprland.conf"
	#	];
		
	#	users.andi = {
	#		directories = [
	#			{directory = ".steam"; mode = "u=rwx, g=, o=rwx";}
	#			{directory = ".config/hypr"; mode = "u=rwx, g=, o=rwx";}
	#			{directory = ".mozilla"; mode = "u=rwx, g= , o=rwx";}
	#		];
	#	};
	};

	programs.fuse.userAllowOther = true;
	home-manager = {
		extraSpecialArgs = {inherit inputs;};
	 	users = {
			"andi" = import ./home.nix;
		};
	};
                        

        boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/root_vg/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
                mkdir -p /btrfs_tmp/old_roots
                timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
                mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                        delete_subvolume_recursively "/btrfs_tmp/$i"
                done
                btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
                delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
        '';

        system.stateVersion = "23.11"; # Did you read the comment?
        
}

