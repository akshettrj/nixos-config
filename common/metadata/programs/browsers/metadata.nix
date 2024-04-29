{ pkgs }:

{
    brave = rec { pkg = pkgs.brave; bin = "${pkg}/bin/brave"; };
    chrome = rec { pkg = pkgs.google-chrome; bin = "${pkg}/bin/google-chrome-stable"; };
    chromium = rec { pkg = pkgs.chromium; bin = "${pkg}/bin/chromium"; };
    firefox = rec { pkg = pkgs.firefox; bin = "${pkg}/bin/firefox"; };
}
