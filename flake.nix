{
	description = "Nixos config flake";
     
  	inputs = {
    		nixpkgs.url = "github:nixos/nixpkgs/";
			
    		disko = {
      			url = "github:nix-community/disko";
      			inputs.nixpkgs.follows = "nixpkgs";
    		};
	
		impermanence = {
	    		url = "github:nix-community/impermanence";
	    	};
		
	    	home-manager = {
	    		url = "github:nix-community/home-manager/";
	    		inputs.nixpkgs.follows = "nixpkgs";
	    	};

		nix-colors.url = "github:misterio77/nix-colors";
		
		hyprland.url = "github:hyprwm/Hyprland";

		snowfall-lib = {
            		url = "github:snowfallorg/lib";
            		inputs.nixpkgs.follows = "nixpkgs";
        	};
  	};
	outputs = inputs: 
		inputs.snowfall-lib.mkFlake {
            		inherit inputs;
            		src = ./.;
			snowfall = {
				meta = {
					name = "dotfiles";
					title = "Sat";
				};
			};

		};

}
