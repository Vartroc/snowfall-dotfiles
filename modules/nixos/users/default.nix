{
lib,
config,
...
}:
{
	users.users."andi" = {
		isNormalUser = true;
		initialPassword = "password";
		extraGroups = ["wheel"]; # Enable sudo for me
	};
}
