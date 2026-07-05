test_that("get_senate_procurements is exported and callable", {
  expect_true(is.function(get_senate_procurements))
  expect_true("url" %in% names(formals(get_senate_procurements)))
})

test_that("get_senate_procurements returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  procurements <- get_senate_procurements()

  expect_s3_class(procurements, "tbl_df")
  expect_true(all(c(
    "opening_date", "file_number", "record", "subject",
    "opening_minutes_url", "opinion_url", "disposition_url", "purchase_order_url"
  ) %in% names(procurements)))
})
