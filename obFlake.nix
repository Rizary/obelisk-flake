{ obeliskFlake }:
with obeliskFlake;
obPlatform.project ./. ({ pkgs, hackGet, ... }: {
  packages = {
    backend = ./backend;
    frontend = ./frontend;
    common = ./common;
  };
  staticFiles = ./static;
})
