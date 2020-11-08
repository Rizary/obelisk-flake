{ beam, rhyolite-obelisk }:
final: prev:
let
  noCheck = p: final.haskell.lib.dontCheck p;
  noHaddock = p: final.haskell.lib.dontHaddock p;
  fast = p: noHaddock (noCheck p);
  obelisk = import rhyolite-obelisk { system = final.system; profiling = true; };
in
{
  obeliskFlake = rec {
    obPlatform =
      let
        inherit (prev) lib;
        hsLib = prev.haskell.lib;
        composeExtensions = prev.lib.composeExtensions;
        haskellOverrides =  lib.foldr composeExtensions obelisk.haskellOverrides [
          (self: super: with hsLib; {
            beam-core = self.callCabal2nix "beam-core" (beam + "/beam-core") {};
            beam-postgres = noCheck (self.callCabal2nix (beam + "/beam-postgres") {});
            beam-migrate = self.callCabal2nix (beam + "/beam-migrate") {};
          })
        ];
      in obelisk // {
        inherit haskellOverrides;
        project = base: projectDefinition:
          obelisk.project base ({...}@args:
            let def = projectDefinition args;
            in def // {
              overrides = composeExtensions haskellOverrides (def.overrides or (_: _: {}));
            });
      };
    obFlake = prev.callPackage ./obFlake.nix {};
  };
}
