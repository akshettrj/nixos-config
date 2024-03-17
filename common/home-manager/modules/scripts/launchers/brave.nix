{ pkgs, scaleFactor }:

pkgs.writeShellScriptBin "launch_brave" ''
  brave --force-device-scale-factor=${toString(scaleFactor)} "$@"
''
