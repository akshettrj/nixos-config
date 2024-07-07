{ lib
, buildGoApplication
}:

buildGoApplication rec {
  pname = builtins.throw "please enter package name in nix/ and rename the file";
  version = "1.0.0";

  src = ../../.;
  pwd = src;

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "Add description here";
    homepage = "Add link here";
    changelog = "${homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "<name>";
  };
}
