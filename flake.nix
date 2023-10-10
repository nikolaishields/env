{
  description = "Home Manager configuration of Nikolai Shields";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = unstable.legacyPackages.${system};
    in {
      homeConfigurations = {
        dwave = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit unstablePkgs;
            name = "Nikolai Shields";
            githubUser = "nikolaishields";
            email = "nshields@dwavesys.com";
            vaultAddr = "https://it-vault.dwavesys.local";
            graphical = true;
            editor = true;
          };
        };
        personal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit unstablePkgs;
            name = "Nikolai Shields";
            githubUser = "nikolaishields";
            email = "nikolai@nikolaishields.com";
            vaultAddr = "https://vault.nikolaishields.com";
          };
        };
      };
    };
}
