{ ... }:

{
    imports = [
        ./nginx.nix
        ./openssh.nix
        ./pipewire.nix
        ./printing.nix
        ./self_hosted
        ./tailscale.nix
        ./telegram_bot_api.nix
    ];
}
