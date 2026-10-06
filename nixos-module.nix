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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install GenOffice. On by default once this module is imported.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { }";
      description = "The GenOffice package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Creates /run/current-system/sw/share/X11/fonts, which the sandboxed app binds.
    fonts.fontDir.enable = true;
  };
}