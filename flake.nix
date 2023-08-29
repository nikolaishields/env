{
  description = "Home Manager configuration of nshields";

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
      genHomeConfiguration = args:
        home-manager.lib.homeManagerConfiguration (rec {
          system = args.system or "x86_64-linux";
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit unstablePkgs; };
        } // args);
    in {
      homeConfigurations."nshields@dwavesys.com" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit unstablePkgs;
            name = "Nikolai Shields";
            user = "nshields";
            githubUser = "nikolaishields";
            email = "nshields@dwavesys.com";
            vaultAddr = "https://it-vault.dwavesys.local";
          };
        };

      #homeConfigurations.dwave = genHomeConfiguation {
      #  extraSpecialArgs = {
      #    username = "nshields";
      #    email = "nshields@dwavesys.com";
      #  };
      #};
      #inherit home-manager;
    };
}
