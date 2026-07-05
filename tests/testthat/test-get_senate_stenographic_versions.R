test_that("get_senate_stenographic_versions is exported and callable", {
  expect_true(is.function(get_senate_stenographic_versions))
  expect_true("url" %in% names(formals(get_senate_stenographic_versions)))
})

test_that("get_senate_stenographic_versions returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  transcripts <- get_senate_stenographic_versions()

  expect_s3_class(transcripts, "tbl_df")
  expect_true(all(c(
    "session_date", "session_type", "session_number", "meeting_number", "url"
  ) %in% names(transcripts)))
})
