test_that("get_vote_detail is exported and callable", {
  expect_true(is.function(get_vote_detail))
  expect_true("ids" %in% names(formals(get_vote_detail)))
})

test_that("get_vote_detail handles an invalid id gracefully (live)", {
  skip_on_cran()
  skip_if_offline()

  result <- get_vote_detail("0")

  expect_s3_class(result, "data.frame")
})
