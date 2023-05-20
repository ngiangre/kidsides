# kidsides 0.5.0

* Added more tests to verify `get_db_path` outputs and `download_sqlite_db` logic
* Places README summary text in an Overview vignette
* Puts other vignettes in vignettes/articles/ folder
* Revises function logic to now download or create kidsides cache directory until consent is given

# kidsides 0.4.2

* Added one test for checking accurate database was downloaded and sqlite connection was made
* Places vignettes into Rbuildignore because of dependency on sqlite download

# kidsides 0.4.1

* Added `on.exit` code, added `askYesNo` permission before downloading the database for the first time, and increased default timeout for function `download_sqlite_db`
* changed '\dontrun' examples to run if interactive, instead.

# kidsides 0.4.0

* First submission to CRAN
