#' Download the Pediatric Drug Safety database
#'
#' Download the database published in Giangreco et al. 2022. This function will prompt to download the database, so the cache directory will be identified and the database will be downloaded to it only after consent. Warning, the size of the uncompressed 'sqlite' file is close to 0.9GB or 900 MB. Use with caution.
#'
#' @param method The method to download the sqlite database. See \code{download.file}
#' @param quiet Whether to download quietly. See \code{download.file}
#' @param timeout Extended download session for downloading this file. Default is 1000 seconds.
#' @param force Whether to force the download of the database. Defaults to FALSE. Needs to be TRUE for database to download. The function will prompt for confirmation.
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
#' if(FALSE){
#' download_sqlite_db() #set force=TRUE if desired to download 0.9GB file to machine
#' }
download_sqlite_db <- function(method="auto",quiet=FALSE,timeout=1e3,force=FALSE) {

    newTimeout <- oldTimeout <- NULL

    #store old timeout, change timeout if supplied, and restore on exit
    newTimeout <- timeout
    on.exit(options(timeout=options()[['timeout']]))
    if(is.numeric(newTimeout)){
        options(timeout=newTimeout)
    }

    if(file.exists(get_db_path()[['dest_file']])){
        message(paste0(
            "Already exists: ",get_db_path()[['dest_file']]
        ))
    }else if(force){

        ans <- utils::askYesNo(
            paste0("kidsides would like to download a 0.9GB 'sqlite' database to your cache. Is that okay?\nThe file will be located at at: ",
                   get_db_path()[['kidsides_cache']], sep = "\n")
        )
        if (!ans) stop("Exiting...", call. = FALSE)

        if(!dir.exists(get_db_path()[['kidsides_cache']])){
            dir.create(get_db_path()[['kidsides_cache']])
        }

        R.utils::downloadFile(
            url = get_db_path()[['url']],
            filename = get_db_path()[['dest_gzfile']],
            method = method,
            quiet = quiet
        )
        R.utils::gunzip(
            get_db_path()[['dest_gzfile']],
            get_db_path()[['dest_file']],
            overwrite=T
        )
    }else{
        message(paste0(
            "Attempt failed to check sqlite exists",
            " or to download from the URL: ",
            get_db_path()[['url']]),"\n",
            " If you want to download for the first time,",
            " set argument force=TRUE"
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
#' if(FALSE){
#' download_sqlite_db()
#' con <- connect_sqlite_db()
#' disconnect_sqlite_db(con)
#' }
connect_sqlite_db <- function(){
    DBI::dbConnect(RSQLite::SQLite(),dbname=get_db_path()[['dest_file']])
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
#' if(FALSE){
#' download_sqlite_db()
#' con <- connect_sqlite_db()
#' disconnect_sqlite_db(con)
#' }
disconnect_sqlite_db <- function(con){
    DBI::dbDisconnect(con)
}

#' Return database cache
#'
#' This function returns the URL, sqlite database file, and cache names to be used for downloading the database to your machine.
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

    kidsides_cache <- tools::R_user_dir("kidsides",which = "cache")

    cache <- dirname(kidsides_cache)

    if(!dir.exists(cache)){
        stop(message(paste0("Cache directory doesn't exist.\n",
                    "Should be located at ",cache)))
    }

    lst <- list()
    lst[['url']] <- url
    lst[['sqlite_gz_file']] <- sqlite_gz_file
    lst[['sqlite_file']] <- strsplit(sqlite_gz_file,"\\.gz")[[1]][1]
    lst[['cache']] <- cache
    lst[['kidsides_cache']] <- kidsides_cache
    lst[['dest_gzfile']] <- paste0(kidsides_cache,"/",sqlite_gz_file)
    lst[['dest_file']] <- paste0(kidsides_cache,"/",lst[['sqlite_file']])
    lst

}
