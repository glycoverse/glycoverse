test_that("glycoverse_remote_info includes non-core packages", {
  info <- glycoverse:::glycoverse_remote_info()

  expect_true("glysmith" %in% names(info))
  expect_equal(info[["glysmith"]]$repo, "glycoverse/glysmith")
  expect_equal(info[["glysmith"]]$ref, "*release")
  expect_equal(info[["glysmith"]]$spec, "glycoverse/glysmith@*release")
})
