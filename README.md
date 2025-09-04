# KiCAD Db Lib

A postgresql db schema and support files for a KiCAD db library

A python based GUI for the db is in development here: [kicad_db_ui](https://github.com/jboulton/kicad_db_gui).

A work in progress, check back soonish for something useable.

## Instructions

1) Install postgresql.
2) Create a database called kicad_lib.
3) Fork this repo.
4) git clone the fork.
5) edit odbc.ini to connect to your kicad_lib database.
6) copy odbc.ini to the appropriate odbc directory for your operating system.
7) Open KiCAD and add DB_LIB_3DMODEL_DIR pointing your forked repo 3d_models directory
8) With KiCAD install the libraries kicad_db_lib.kicad_dbl, symbols/db_library.kicad_sym, and footprints/db_footprints.pretty
