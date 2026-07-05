test_that("get_senators is exported and callable", {
  expect_true(is.function(get_senators))
  expect_true("url" %in% names(formals(get_senators)))
})

test_that("get_senators returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  senators <- get_senators()

  expect_s3_class(senators, "tbl_df")
  expect_true(nrow(senators) > 0)
  expect_true(all(c("id", "bloc", "last_name", "first_name", "province") %in% names(senators)))
})
