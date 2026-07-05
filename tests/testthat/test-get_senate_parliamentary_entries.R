test_that("get_senate_parliamentary_entries is exported and callable", {
  expect_true(is.function(get_senate_parliamentary_entries))
  expect_true("url" %in% names(formals(get_senate_parliamentary_entries)))
})

test_that("get_senate_parliamentary_entries returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  entries <- get_senate_parliamentary_entries()

  expect_s3_class(entries, "tbl_df")
  expect_true(all(c("meeting_date", "url") %in% names(entries)))
})
