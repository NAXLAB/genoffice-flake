{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:

let
  pname = "genoffice";
  version = "0.5.149";

  src = fetchurl {
    url = "https://github.com/genspark-ai/genoffice/releases/download/linux-v${version}/GenOffice-${version}.AppImage";
    hash = "sha256-itKyy7GKQutDg/L5KBTyTGyXbvd7lDBDx7k+lUfO10I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    # Desktop entry + icon
    install -Dm444 ${appimageContents}/genoffice.desktop \
      $out/share/applications/genoffice.desktop
    install -Dm444 ${appimageContents}/genoffice.png \
      $out/share/icons/hicolor/512x512/apps/genoffice.png

    substituteInPlace $out/share/applications/genoffice.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=genoffice %U'

    # Wayland support when NIXOS_OZONE_WL is set
    wrapProgram $out/bin/genoffice \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = {
    description = "AI-native office suite: word processor, spreadsheet, presentations and PDF";
    homepage = "https://github.com/genspark-ai/genoffice";
    license = lib.licenses.asl20;
    mainProgram = "genoffice";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
