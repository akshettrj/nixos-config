{ lib
, buildGoApplication
, nix-filter
, self
}:

let

  localSrc = nix-filter {
    name = "neobutlergo";
    root = ../../.;
    include = [
      ../../gomod2nix.toml
      ../../go.mod
      ../../go.sum
    ];
  };

  lastReleaseVersion = "0.0.0";

  devVersion = (
    if (builtins.hasAttr "shortRev" self) then
      self.shortRev
    else if (builtins.hasAttr "dirtyShortRev" self) then
      self.dirtyShortRev
    else
      "dev"
  );

in buildGoApplication {
  pname = builtins.throw "please enter package name in nix/ and rename the file";
  version = devVersion;

  src = localSrc;
  pwd = localSrc;

  ldflags = [ "-s" "-w" ];

  meta = with lib; rec {
    description = "Add description here";
    homepage = "Add link here";
    changelog = "${homepage}/compare/v${lastReleaseVersion}...main";
    license = licenses.mit;
    mainProgram = "<name>";
  };
}
