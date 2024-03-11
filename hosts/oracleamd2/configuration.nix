{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common/nixos/oracle_amd/configuration.nix
  ];

  hostname = "oracleamd2";

  users.users.akshettrj.openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZwkmaaZ+i9usypmporvPyirpVCqoELZ1xa8HCTWBCRzFcg2Ym/S6TtISJI0uv3lV4AuosYWU9pNj20u17UUZpf8L6PbRRfdchKoll4ZdkAg+BU8TTlFAIuKexW1skq+TvaV1S4cFPY28iHhzp61EtfILxHwgRf3OZUM4UkoNoVxIkPAa+D3gS4SR+8JuhD+lcNvz7IMJ4D2b6+u/9u0fe9bBJdzRC/larHiY5Pi03p9ewnCAw3QndYZ7fF9cR9tIlvT8zXVwzW1DmURjKW3q6JfBkhQYgtDA8jBEjtgi9haqo+qWYsp2nFu7grikP1/Fb6nCokphuroLUwdTOELAr akshettrj@ltrcakki''];
}
