{
  description = "GenOffice - AI-native office suite (docs, sheets, slides, PDF)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = false;
      };
    in
    {
      packages.${system} = {
        genoffice = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.genoffice;
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.genoffice}/bin/genoffice";
      };

      nixosModules.default = ./nixos-module.nix;

      overlays.default = final: _prev: {
        genoffice = final.callPackage ./package.nix { };
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
