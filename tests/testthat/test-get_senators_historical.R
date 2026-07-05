test_that("get_senators_historical is exported and callable", {
  expect_true(is.function(get_senators_historical))
  expect_true("url" %in% names(formals(get_senators_historical)))
})

test_that("get_senators_historical returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  senators_hist <- get_senators_historical()

  expect_s3_class(senators_hist, "tbl_df")
  expect_true(nrow(senators_hist) > 0)
  expect_true(all(c("id", "name", "start_legal", "end_legal", "province") %in% names(senators_hist)))
})
