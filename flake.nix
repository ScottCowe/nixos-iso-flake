{
  description = "Scott Cowe's NixOS installer flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, ... }@inputs: let
    mkISO = pkgs: system:
      pkgs.lib.nixosSystem {
        modules = [
          "${pkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

          {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            networking.wireless.enable = false;
            networking.networkmanager.enable = true;

            nixpkgs.hostPlatform = "${system}"; 
          }
        ];
      };
  in {
    nixosConfigurations.iso = mkISO inputs.nixpkgs "x86_64-linux";
    packages."x86_64-linux".default = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
