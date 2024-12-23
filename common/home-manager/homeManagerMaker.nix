{
  pkgs,
  inputs,
  config,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    inherit inputs pkgs;
    propheci = config.propheci;
  };
  modules = [ ./homeManagerInitModule.nix ];
}
