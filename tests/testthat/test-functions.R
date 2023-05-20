test_that("URL is correct",{

    expect_equal(
        get_db_path()[['url']],
        "https://tlab-kidsides.s3.amazonaws.com/data/effect_peds_19q2_v0.3_20211119.sqlite.gz"
    )

})

test_that("get_db_path() returns list",{

    expect_equal(
        class(get_db_path()),
        "list"
    )

})

test_that("get_db_path() returns more than 1 element",{

    expect_true(
        length(get_db_path())>1
    )

})

test_that("Gives message that it does not download sqlite file unless forced to",{
    expect_message(
        download_sqlite_db()
    )
})

if(file.exists(get_db_path()[['dest_file']])){
    test_that("Downloaded file is correct and sqlite correction is correct",{

        con <- connect_sqlite_db()

        expect_equal(
            attr(con,"class")[1],
            "SQLiteConnection"
        )

        expect_equal(
            basename(attr(con,"dbname")),
            basename(get_db_path()[['dest_file']])
        )

        disconnect_sqlite_db(con)

    })

}
