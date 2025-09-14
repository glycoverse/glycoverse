inform_startup <- function(msg, ...) {
  if (is.null(msg)) {
    return()
  }
  rlang::inform(msg, ..., class = "packageStartupMessage")
}

#' List all packages in the glycoverse
#'
#' @param include_self Include glycoverse in the list?
#' @export
#' @examples
#' glycoverse_packages()
glycoverse_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("glycoverse")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "glycoverse")
  }

  names
}

invert <- function(x) {
  if (length(x) == 0) {
    return()
  }
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}