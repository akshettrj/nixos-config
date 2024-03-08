{ config, pkgs, lib, ... }:

{
  options = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    nvidia = {
      enable = mkOption { type = types.bool; description = "Enable NVIDIA graphics card drivers"; };

      package = mkOption {
        type = types.anything;
        example = config.boot.kernelPackages.nvidiaPackages.stable;
        description = ''
          The package to be used for NVIDIA drivers.
          Basically stable, beta, production etc.
        '';
      };

      intelBusId = mkOption {
        type = types.str;
        example = "PCI:0:2:0";
        description = ''
          The Bus ID value for the Intel integrated graphics card
          Get this value by running `sudo lshw -c display`
        '';
      };

      nvidiaBusId = mkOption {
        type = types.str;
        example = "PCI:0:2:0";
        description = ''
          The Bus ID value for the NVIDIA graphics card
          Get this value by running `sudo lshw -c display`
        '';
      };
    };
  };

  config = lib.mkIf config.nvidia.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.mesa.drivers ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = config.nvidia.package;

      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      prime = {
        intelBusId = config.nvidia.intelBusId;
        nvidiaBusId = config.nvidia.nvidiaBusId;
      };
    };
  };
}
