{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, unstable, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = unstable.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nshields = import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit unstablePkgs;
              #  name = "Nikolai Shields";
              #  githubUser = "nikolaishields";
              #  email = "nshields@dwavesys.com";
                vaultAddr = "https://it-vault.dwavesys.local";
              #  graphical = true;
              #  editor = true;
              };
            }
          ];
        };
      };
    };
}
