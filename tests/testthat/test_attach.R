test_that("message lists all core glycoverse packages", {
  local_mocked_bindings(package_version_h = function(x) "1.0.0")
  expect_snapshot(cat(glycoverse_attach_message(core)))
})