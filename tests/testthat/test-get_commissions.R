test_that("get_commissions is exported and callable", {
  expect_true(is.function(get_commissions))
  expect_true("url" %in% names(formals(get_commissions)))
})

test_that("get_commissions returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  commissions <- get_commissions()

  expect_s3_class(commissions, "tbl_df")
  expect_true(nrow(commissions) > 0)
  expect_true(all(c("name", "type") %in% names(commissions)))
})
