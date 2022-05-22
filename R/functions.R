#' Download the Pediatric Drug Safety database
#'
#' Thus function downloads the database published in Giangreco et al. 2022.
#'
#' @param url The url of the sqlite database
#' @param path The path where to dump the sqlite database.
#' @param destfile The path and filename where to dump the sqlite database. See \code{download.file}
#' @param method The method to download the sqlite database. See \code{download.file}
#' @param quiet Whether to download quietly. See \code{download.file}
#'
#'
#' @return TRUE, invisibly
#' @export
#'
#' @importFrom utils download.file
#'

download_sqlite_db <- function(url="https://pds-database.s3.amazonaws.com/effect_peds_19q2_v0.3_20211119.sqlite",path="./",destfile=paste0(path,"effect_peds_19q2_v0.3_20211119.sqlite"),method="auto",quiet=TRUE) {
  download.file(
      url = url,
      destfile = destfile,
      method = method,
      quiet = quiet)
}

#' Connect to the Pediatric Drug Safety database
#'
#' This function makes a sqlite connection from the downloaded database.
#'
#' @rdname connect_sqlite_db
#'
#' @param dbname The path to the sqlite file
#'
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#'
#' @return SQLite connection, invisibly
#' @export
#'
connect_sqlite_db <- function(dbname="./effect_peds_19q2_v0.3_20211119.sqlite"){
    DBI::dbConnect(RSQLite::SQLite(),dbname=dbname)
}

#' Disconnect from the Pediatric Drug Safety database
#'
#' This function disconnects the sqlite database connection.
#'
#' @rdname disconnect_sqlite_db
#'
#' @param con The sqlite connection
#'
#' @importFrom DBI dbDisconnect
#'
#' @return TRUE, invisibly
#' @export
#'
disconnect_sqlite_db <- function(con){
    DBI::dbDisconnect(con)
}
