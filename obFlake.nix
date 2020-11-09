{ obeliskFlake, patch }:
with obeliskFlake;
obPlatform.project ./. ({ pkgs, hackGet, ... }:
let

  noCheck = p: pkgs.haskell.lib.dontCheck p;
  noHaddock = p: pkgs.haskell.lib.dontHaddock p;
  fast = p: noHaddock (noCheck p);
  haskell-lib = pkgs.haskell.lib;
in {
  packages = {
    ios.bundleIdentifier = null;
    ios.bundleName = null;
    backend = ./backend;
    frontend = ./frontend;
    common = ./common;
  };
  staticFiles = ./static;
})
