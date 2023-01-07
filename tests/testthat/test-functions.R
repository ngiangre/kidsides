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
