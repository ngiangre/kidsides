test_that("URL is correct",{

    expect_equal(
        get_db_path()[['url']],
        "https://pds-database.s3.amazonaws.com/effect_peds_19q2_v0.3_20211119.sqlite"
    )

})

test_that("get_db_path() returns list",{

    expect_equal(
        class(get_db_path()),
        "list"
    )

})
