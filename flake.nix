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

            networking = {
            #   useDHCP = false;
            #   interfaces = {
            #     enp5s0.ipv4.addresses = [{
            #       address = "192.168.100";
            #       prefixLength = 24;
            #     }];
            #     enp4s0.ipv4.addresses = [{
            #       address = "192.168.101";
            #       prefixLength = 24;
            #     }];
            #   };
              firewall.allowedTCPPorts = [ 22 ];
            };

            nixpkgs.hostPlatform = "${system}"; 

            services.openssh.enable = true;
          }
        ];
      };
  in {
    nixosConfigurations.iso = mkISO inputs.nixpkgs "x86_64-linux";
    packages."x86_64-linux".default = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
