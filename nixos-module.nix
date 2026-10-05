{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.genoffice;
in
{
  options.programs.genoffice = {
    enable = lib.mkEnableOption "GenOffice, an AI-native office suite";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { }";
      description = "The GenOffice package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
