test_that("get_senate_votes is exported and callable", {
  expect_true(is.function(get_senate_votes))
  expect_true(all(c("years", "step", "max_pages") %in% names(formals(get_senate_votes))))
})

test_that("get_senate_votes returns expected structure (live)", {
  skip_on_cran()
  skip_if_offline()

  votes <- get_senate_votes(years = "2024", max_pages = 1)

  expect_s3_class(votes, "data.frame")
  expect_true("year" %in% names(votes))
})
