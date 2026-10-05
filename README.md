# genoffice-flake

Nix flake and NixOS module for [GenOffice](https://github.com/genspark-ai/genoffice), an AI-native office suite (docs, sheets, slides, PDF).

It wraps the upstream Linux AppImage. x86_64-linux only.

## NixOS

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    genoffice.url = "github:NAXLAB/genoffice-flake";
    genoffice.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, genoffice, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        genoffice.nixosModules.default
        { programs.genoffice.enable = true; }
      ];
    };
  };
}
```

## Try it without installing
```
nix run github:NAXLAB/genoffice-flake
```

## License

The Nix files in this repo are MIT licensed (see `LICENSE`). GenOffice itself is licensed separately by its authors (Apache-2.0); its names and logos are trademarks of Mainfunc, Inc.
