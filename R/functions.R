#' Download the Pediatric Drug Safety database
#'
#' Download the database published in Giangreco et al. 2022. Warning, the size of the uncompressed 'sqlite' file is close to 900 MB. Use wit caution
#'
#' @param method The method to download the sqlite database. See \code{download.file}
#' @param quiet Whether to download quietly. See \code{download.file}
#' @param timeout Extended download session for downloading this file. Default is 1000 seconds.
#' @param force Whether to force the download of the database. Defaults to FALSE.
#'
#'
#' @return TRUE, invisibly
#' @export
#'
#' @importFrom R.utils downloadFile gunzip
#' @importFrom tools R_user_dir
#' @importFrom utils askYesNo
#'
#' @examples
#' if(interactive()){
#' download_sqlite_db()
#' }
download_sqlite_db <- function(method="auto",quiet=FALSE,timeout=1e3,force=FALSE) {

    newTimeout <- oldTimeout <- NULL

    #store old timeout, change timeout if supplied, and restore on exit
    newTimeout <- timeout
    on.exit(options(timeout=options()[['timeout']]))
    if(is.numeric(newTimeout)){
        options(timeout=newTimeout)
    }

    if(!file.exists(get_db_path()[['destname']]) | force){

        ans <- utils::askYesNo(paste0("kidsides would like to download a 'sqlite' database to your cache directory at:\n",dirname(get_db_path()[['dest_file']]), ". Is that okay?", sep = "\n"))
        if (!ans) stop("Exiting...", call. = FALSE)


        R.utils::downloadFile(
            url = get_db_path()[['url']],
            filename = get_db_path()[['dest_file']],
            method = method,
            quiet = quiet
        )
        R.utils::gunzip(
            get_db_path()[['dest_file']],
            get_db_path()[['destname']],
            overwrite=T
        )
    }else if(file.exists(get_db_path()[['dest_file']])){
        message(paste0(
            get_db_path()[['dest_file']]," already exists!"
            ))
    }else{
        message(paste0(
            "Attempt failed to check sqlite exists",
            " or to download from the URL: ",
            get_db_path()[['url']])
            )
    }

}

#' Connect to the Pediatric Drug Safety database
#'
#' Establish a sqlite connection from the downloaded database.
#'
#' @rdname connect_sqlite_db
#'
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#'
#' @return SQLite connection
#' @export
#'
#' @examples
#' if(interactive()){
#' download_sqlite_db()
#' con <- connect_sqlite_db()
#' disconnect_sqlite_db(con)
#' }
connect_sqlite_db <- function(){
    DBI::dbConnect(RSQLite::SQLite(),dbname=get_db_path()[['destname']])
}

#' Disconnect from the Pediatric Drug Safety database
#'
#' Disconnect the sqlite database connection.
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
#' @examples
#' if(interactive()){
#' download_sqlite_db()
#' con <- connect_sqlite_db()
#' disconnect_sqlite_db(con)
#' }
disconnect_sqlite_db <- function(con){
    DBI::dbDisconnect(con)
}

#' Return database cache
#'
#' This function identifies and returns the cache location for the database on your machine
#'
#' @importFrom tools R_user_dir
#'
#' @return list
#' @export
#'
#' @examples
#' get_db_path()
#'
get_db_path <- function(){

    url <- sqlite_file <- path <- full_path <- lst <- NULL

    url <- "https://tlab-kidsides.s3.amazonaws.com/data/effect_peds_19q2_v0.3_20211119.sqlite.gz"
    sqlite_gz_file <- basename(url)

    path <- tools::R_user_dir("kidsides",which = "cache")

    full_path <- paste0(dirname(path),"/",
                       basename(path))

    if(!dir.exists(full_path)){
        dir.create(full_path)
    }

    lst <- list()
    lst[['url']] <- url
    lst[['dest_file']] <- paste0(full_path,"/",sqlite_gz_file)
    lst[['sqlite_file']] <- strsplit(sqlite_gz_file,"\\.gz")[[1]][1]
    lst[['destname']] <- paste0(full_path,"/",lst[['sqlite_file']])
    lst

}
