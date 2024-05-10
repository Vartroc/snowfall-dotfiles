{
disko.devices = {
	disk = {
		disk0 = {
			type = "disk";
			device = "/dev/nvme1n1";
			content = {
				type = "gpt";
				partitions = {
					esp = {
						name = "ESP";
						size = "512M";
						type = "EF00";
						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/boot";
						};
					};

					root = {
						name = "root0";
						size = "100%";
						content = {
							type = "lvm_pv";
							vg = "root_vg";
						};
					};
				};
			};
		};
		
		disk1 = {
			type = "disk";
			device = "/dev/nvme0n1";
			content = {
				type = "gpt";
				partitions = {
					windows = {
						name = "windows";
						size = "64G";
					};
					
					root = {
						name = "root1";
						size = "100%";
						content = {
							type = "lvm_pv";
							vg = "root_vg";
						};
					};
				};
			};
		};
	};


	lvm_vg = {
		root_vg = {
			type = "lvm_vg";
			lvs = {
				root = {
					size = "25%FREE";
					content = {
						type = "btrfs";
						extraArgs = ["-f"];
						subvolumes = {
							"/root" = {
						 		 mountpoint = "/";
							};

							"/persist" = {
								mountOptions = ["subvol=persist" "noatime"];
								mountpoint = "/persist";
							};
							
							"/nix" = {
								mountOptions = ["subvol=nix" "noatime"];
								mountpoint = "/nix";
							};
						};
					};
				};

				games = {
					size = "100%FREE";
					content = {
						type = "btrfs";
						extraArgs = ["-f"];
						subvolumes = {
							"/games" = {
								mountOptions = ["subvol=games" "noatime"];
								mountpoint = "/games";
							};
						};
					};
				};
			};
		};
	};
};
}
