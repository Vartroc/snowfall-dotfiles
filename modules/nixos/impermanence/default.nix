{
  	lib,
	config,
	inputs,
  	...
}:

{
let
	cfg = config.custom.persist;
in

	options.custom.persist = {

		enable = lib.mkEnableOption "Weather or not to enable impermanence";
		
    		root = {
      			directories = lib.mkOption {
        			type = lib.types.listOf lib.types.str;
        			default = [ ];
        			description = "Directories to persist in root filesystem";
      			};
      			files = lib.mkOption {
        			type = lib.types.listOf lib.types.str;
        			default = [ ];
        			description = "Files to persist in root filesystem";
      			};
      			cache = lib.mkOption {
        			type = lib.types.listOf lib.types.str;
        			default = [ ];
        			description = "Directories to persist, but not to snapshot";
			cache_files = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				default = [ ];
				descriptions = "Files to persist, but not to snapshot";
			};
    		};
	
	    	home = {
	      		directories = lib.mkOption {
	        		type = lib.types.listOf lib.types.str;
	        		default = [ ];
	        		description = "Directories to persist in home directory";
	      		};
	      		files = lib.mkOption {
	        		type = lib.types.listOf lib.types.str;
	        		default = [ ];
	        		description = "Files to persist in home directory";
	      		};
	    	};
	};

	impermanence = lib.mkIf cfg.enable {
		fileSystems."/persist".neededForBoot = true;
		fileSystems."/".neededForBoot = true;
		programs.fuse.userAllowOther = true;
		
		# shut sudo up
		security.sudo.extraConfig = "Defaults lecture=never";

		# setup root persistence
		environment.persistence = {
		  	"/persist" = {
		      		hideMounts = true;
				files = [ "/etc/machine-id" ] ++ cfg.root.files;
		      		directories = [
		        		"/var/log" # systemd journal is stored in /var/log/journal
					"/etc/lib/nixos"
		      		] ++ cfg.root.directories;
	
			"/persist/cache" = {
				hideMounts = true;
				directories = cfg.root.cache;
				files = cfg.root.cache
			};
		};
				
		# Using Home-Manager, because for my use case, it was actually working lol
		home.persistence = {
			"/persist/home" = {
				hideMounts = true;
		       		files = cfg.home.files;
		       		directories = cfg.home.directories;
			};
		};
	
		# Wiping the drive
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
}


