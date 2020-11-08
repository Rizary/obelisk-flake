{ obeliskFlake }:
with obeliskFlake;
obPlatform.project ./. ({ pkgs, hackGet, ... }: {
  packages = {

    ios.bundleIdentifier = null;
    ios.bundleName = null;
    backend = ./backend;
    frontend = ./frontend;
    common = ./common;
  };
  staticFiles = ./static;
})
