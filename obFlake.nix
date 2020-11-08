{ pkgs, obeliskFlake }:
with obeliskFlake;
obPlatform.project ./. ({ pkgs, hackGet, ... }: {
  packages = {
    backend = ./backend;
    frontend = ./frontend;
    common = ./common;
  };
  overrides = self: super: {
      th-orphans = pkgs.haskell.lib.doJailbreak super.th-orphans;
  };
  staticFiles = ./static;
})
