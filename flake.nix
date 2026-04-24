# @path: ~/projects/nixproj/derivations/input-overlay/flake.nix
# @author: redskaber
# @datetime: 2026-04-25
# @directory: https://nix.dev/manual/nix/2.33/command-ref/new-cli/nix3-flake.html

{
  description = "kilig(redskaber)'s declarative derivations environment";

  inputs = {
    # Nixpkgs (url version)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  } @ inputs :
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
  {
    # nix build .#packages.x86_64-linux.default
    packages.${system}.default = (import ./package.nix { inherit pkgs; });
  };

}


