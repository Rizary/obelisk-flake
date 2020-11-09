{
  description = "todomvc-nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell/packages-from";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.rhyolite-obelisk = { url = "github:obsidiansystems/rhyolite/develop"; flake = false; };
  inputs.beam = { url = "github:haskell-beam/beam/master"; flake = false; };
  inputs.patch = { url = "github:/reflex-frp/patch/develop"; flake = false; };

  outputs = { self, nixpkgs, flake-utils, devshell, beam, rhyolite-obelisk, patch }:
    {
      overlay = import ./overlay.nix { inherit beam rhyolite-obelisk patch; };
    }
    //
    (
      flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            # Makes the config pure as well. See <nixpkgs>/top-level/impure.nix:
            config = {
                allowBroken = true;
                permittedInsecurePackages = [
                  "openssl-1.0.2u"
                ];
            };
            overlays = [
                devshell.overlay
                self.overlay
            ];
          };
        in
        {
          legacyPackages = pkgs.obeliskFlake;

          packages = flake-utils.lib.flattenTree pkgs.obeliskFlake;

          devShell = import ./shell.nix { inherit pkgs; };

          checks = { };
        }
      )
    );
}
