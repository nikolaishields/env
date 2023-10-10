all: build

.PHONY:
build:
	NIXPKGS_ALLOW_UNFREE=1 home-manager build --flake .#dwave --impure

.PHONY:
update:
	NIXPKGS_ALLOW_UNFREE=1 nix flake update .

.PHONY:
switch: update build 
	NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#dwave --impure -b backup

.PHONY:
install: 
	nix run home-manager/release-23.05 -- init --switch

.PHONY:
clean:
	sudo rm -rf result
