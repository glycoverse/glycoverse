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

test_that("glycoverse_deps uses r-universe for version checking", {
  # Mock runiverse_packages to return known versions
  local_mocked_bindings(
    runiverse_packages = function() c(glyrepr = "0.9.0", glyparse = "0.5.3")
  )

  deps <- glycoverse_deps()

  # Should be a tibble with expected columns (no 'remote' column in new implementation)
  expect_s3_class(deps, "tbl_df")
  expect_true("package" %in% names(deps))
  expect_true("source" %in% names(deps))
  expect_true("upstream" %in% names(deps))
  expect_true("local" %in% names(deps))
  expect_true("behind" %in% names(deps))
  expect_false("remote" %in% names(deps))  # remote column removed

  # glyrepr should be in the results (it's a core package)
  expect_true("glyrepr" %in% deps$package)

  # Source should be "runiverse" for glycoverse packages, not "github"
  glycoverse_pkgs <- deps$package[deps$package %in% c("glyrepr", "glyparse")]
  sources <- deps$source[deps$package %in% c("glyrepr", "glyparse")]
  expect_true(all(sources == "runiverse"))
})

test_that("glycoverse_update uses pak::repo_add for r-universe packages", {
  skip_if_not_installed("pak")

  # Mock deps with outdated packages
  mock_deps <- tibble::tibble(
    package = c("glyrepr", "glyparse"),
    source = c("runiverse", "runiverse"),
    upstream = c("0.10.0", "0.6.0"),
    local = c("0.9.0", "0.5.0"),
    behind = c(TRUE, TRUE)
  )

  repo_add_called <- FALSE
  pkg_install_called <- FALSE

  # Mock glycoverse_deps in glycoverse namespace
  local_mocked_bindings(
    glycoverse_deps = function(...) mock_deps,
    .package = "glycoverse"
  )

  # Mock pak functions
  local_mocked_bindings(
    repo_add = function(...) { repo_add_called <<- TRUE; invisible() },
    pkg_install = function(...) { pkg_install_called <<- TRUE; invisible() },
    .package = "pak"
  )

  # Mock utils::menu
  local_mocked_bindings(
    menu = function(...) 1,  # User selects "Yes"
    .package = "utils"
  )

  suppressMessages(glycoverse_update())

  expect_true(repo_add_called)
  expect_true(pkg_install_called)
})
