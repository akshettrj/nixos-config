{
    cp = "cp -rvi";
    rm = "rm -vi";
    rsync = "rsync -urvP";
    nh-switch = "nh os switch ~/.config/nixos-flake -- --no-eval-cache --accept-flake-config --show-trace";
    nh-boot = "nh os boot ~/.config/nixos-flake -- --no-eval-cache --accept-flake-config --show-trace";
}
