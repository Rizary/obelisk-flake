{ pkgs }:

with pkgs;

mkDevShell {
  name = "obelisk-flake";
  motd = "otherthing";
  commands = [
    {
      name = "ls-reflex";
      help = "ls-reflex folder";
      command = "ls ${obeliskFlake.obFlake.ghcjs.frontend} || echo '''ls failed''' ";
    }
  ];

  bash = {
    extra = ''
    '';
    interactive = ''
    '';
  };

  env = {
    DATABASE_URL="postgresql://ob_dbuser:ob_dbpass@localhost:5432/ob_db";
    PGHOST="localhost";
    PGPORT="5432";
    PGDATABASE="ob_db";
    PGUSER="ob_dbuser";
    PGPASSWORD="ob_dbpass";
  };
  packages = [
    # Haskell
    obeliskFlake.obPlatform.command

    # database
    postgresql
  ];
}
