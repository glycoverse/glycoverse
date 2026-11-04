.with_conflict_packages <- function(objects, code) {
  package_names <- paste0(
    "package:glycoverse_conflict_test_",
    seq_along(objects)
  )
  for (i in rev(seq_along(objects))) {
    attach(
      list(conflict_test_fun = objects[[i]]),
      name = package_names[[i]],
      warn.conflicts = FALSE
    )
  }
  on.exit(
    {
      for (package in package_names) {
        detach(package, character.only = TRUE)
      }
    },
    add = TRUE
  )
  code(package_names)
}

test_that("conflicts exclude non-function objects from package names", {
  first <- function() 1
  second <- function() 2
  .with_conflict_packages(list(42, first, second), function(packages) {
    expect_identical(
      confirm_conflict(packages, "conflict_test_fun"),
      packages[2:3]
    )
  })
})

test_that("conflicts omit identical re-exports while preserving search order", {
  first <- function() 1
  second <- function() 2
  .with_conflict_packages(list(first, first, second), function(packages) {
    expect_identical(
      confirm_conflict(packages, "conflict_test_fun"),
      packages[c(1, 3)]
    )
  })
})

test_that("non-functions and identical re-exports alone are not conflicts", {
  fun <- function() 1
  .with_conflict_packages(list(42, fun, fun), function(packages) {
    expect_null(confirm_conflict(packages, "conflict_test_fun"))
  })
})
