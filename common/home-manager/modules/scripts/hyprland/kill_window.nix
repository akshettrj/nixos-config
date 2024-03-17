{ pkgs, hyprland-package }:

pkgs.writeShellScriptBin "kill_window" ''
  if [ "$(${hyprland-package}/bin/hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
    ${pkgs.xdotool}/bin/xdotool getactivewindow windowunmap
  else
    ${hyprland-package}/bin/hyprctl dispatch killactive ""
  fi
''
