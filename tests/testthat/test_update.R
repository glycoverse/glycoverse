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

test_that("runiverse_packages fetches package list from r-universe", {
  # Mock the API response
  mock_response <- '[{"Package": "glymotif", "Version": "0.11.2"}, {"Package": "glyparse", "Version": "0.5.3"}]'
  mock_data <- jsonlite::fromJSON(mock_response)

  # Test that function returns named vector
  local_mocked_bindings(
    fromJSON = function(...) mock_data,
    .package = "jsonlite"
  )

  result <- runiverse_packages()
  expect_type(result, "character")
  expect_named(result)
  expect_equal(result["glymotif"], c(glymotif = "0.11.2"))
})

test_that("runiverse_version returns version for package", {
  all_pkgs <- c(glymotif = "0.11.2", glyparse = "0.5.3")

  expect_equal(runiverse_version("glymotif", all_pkgs), "0.11.2")
  expect_equal(runiverse_version("nonexistent", all_pkgs), NA_character_)
  expect_equal(runiverse_version("glymotif"), NA_character_)  # when API fails
})
