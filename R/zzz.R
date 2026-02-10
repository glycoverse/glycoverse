.onAttach <- function(...) {
  if (is_loading_for_tests()) {
    return(invisible())
  }

  attached <- glycoverse_attach()
  inform_startup(glycoverse_attach_message(attached))

  if (is_attached("conflicted")) {
    return(invisible())
  }

  conflicts <- glycoverse_conflicts()
  inform_startup(glycoverse_conflict_message(conflicts))
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}

is_loading_for_tests <- function() {
  !interactive() && identical(Sys.getenv("DEVTOOLS_LOAD"), "glycoverse")
}
