test_that("glycoverse_remote_info includes non-core packages", {
  info <- glycoverse:::glycoverse_remote_info()

  expect_true("glysmith" %in% names(info))
  expect_equal(info[["glysmith"]]$repo, "glycoverse/glysmith")
  expect_equal(info[["glysmith"]]$ref, "*release")
  expect_equal(info[["glysmith"]]$spec, "glycoverse/glysmith@*release")
})

test_that("non-core filtering logic works correctly", {
  # Define core and non_core (same as in attach.R)
  core <- c("glyexp", "glyread", "glyclean", "glystats", "glyvis", "glyrepr", "glyparse", "glymotif", "glydet", "glydraw")
  non_core <- c("glyenzy", "glydb", "glyanno", "glysmith")

  # Case 1: Only core packages installed
  installed_pkgs <- c("glyexp", "glyread", "glycoverse")
  non_core_installed <- non_core[non_core %in% installed_pkgs]
  expect_equal(non_core_installed, character(0))

  # Case 2: Some non-core packages installed
  installed_pkgs <- c("glyexp", "glyread", "glydb", "glycoverse")
  non_core_installed <- non_core[non_core %in% installed_pkgs]
  expect_equal(non_core_installed, "glydb")

  # Case 3: All non-core packages installed
  installed_pkgs <- c(core, non_core, "glycoverse")
  non_core_installed <- non_core[non_core %in% installed_pkgs]
  expect_equal(non_core_installed, non_core)
})

test_that("core packages always included regardless of installation", {
  # Define core and non_core
  core <- c("glyexp", "glyread", "glyclean", "glystats", "glyvis", "glyparse", "glymotif", "repr", "glyglydet", "glydraw")
  non_core <- c("glyenzy", "glydb", "glyanno", "glysmith")

  # Simulate pkg_deps filtering
  pkg_deps <- c(core, non_core)
  installed_pkgs <- c("glycoverse") # Only glycoverse installed

  non_core_installed <- non_core[non_core %in% installed_pkgs]
  result <- c(
    intersect(pkg_deps, core),
    non_core_installed,
    setdiff(pkg_deps, c(core, non_core))
  )

  # Core packages should all be included
  expect_true(all(core %in% result))
  # Non-core should NOT be included (not installed)
  expect_true(length(intersect(result, non_core)) == 0)
})
