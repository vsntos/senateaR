test_that("get_bulletins is exported and callable", {
  expect_true(is.function(get_bulletins))
  expect_true("url" %in% names(formals(get_bulletins)))
})

test_that("get_bulletins returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  bulletins <- get_bulletins()

  expect_s3_class(bulletins, "tbl_df")
  expect_true(all(c("session_date", "bulletin_number", "url") %in% names(bulletins)))
})
