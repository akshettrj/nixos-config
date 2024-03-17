{ pkgs, lib, config, ... }:

{
  options = let
    inherit (lib) mkOption types;
  in {
    brave = {
      enable = mkOption { type = types.bool; };
      scaleFactor = mkOption { type = types.number; };
    };
  };

  config = let
    launch_brave = import ../scripts/launchers/brave.nix { inherit pkgs; scaleFactor = config.brave.scaleFactor; };
  in lib.mkIf config.brave.enable {
    xdg.desktopEntries.brave-browser = {
      name = "Brave";
      exec = "${launch_brave}/bin/launch_brave %U";
      categories = [ "Network" "WebBrowser" ];
      genericName = "Web Browser";
      icon = "brave-browser";
      comment = "Access the Internet";
      mimeType = [
        "application/pdf"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/ipfs"
        "x-scheme-handler/ipns"
      ];
      prefersNonDefaultGPU = true;
      actions = {
        "new-window" = {
          name = "New Window";
          exec = "${launch_brave}/bin/launch_brave";
        };
        "new-private-window" = {
          name = "New Incognito Window";
          exec = "${launch_brave}/bin/launch_brave --incognito";
        };
      };
    };
  };
}
