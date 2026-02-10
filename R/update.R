#' Update glycoverse packages
#'
#' This checks r-universe for all glycoverse packages (and optionally,
#' their dependencies) and reports which ones have newer versions available.
#' You can then choose to update automatically or get manual instructions.
#'
#' @inheritParams glycoverse_deps
#' @export
#' @examples
#' \dontrun{
#' glycoverse_update()
#' }
glycoverse_update <- function(recursive = FALSE, repos = getOption("repos")) {
  deps <- glycoverse_deps(recursive, repos)
  behind <- dplyr::filter(deps, behind)

  if (nrow(behind) == 0) {
    cli::cat_line("All glycoverse packages up-to-date")
    return(invisible())
  }

  cli::cat_line(cli::pluralize(
    "The following {cli::qty(nrow(behind))}package{?s} {?is/are} out of date:"
  ))
  cli::cat_line()
  cli::cat_bullet(
    format(behind$package),
    " (",
    behind$local,
    " -> ",
    behind$upstream,
    ")"
  )
  cli::cat_line()

  q <- utils::menu(c("Yes", "No"), title = cli::format_inline("Do you want to update these {nrow(behind)} packages now?"))

  if (q != 1) {
    show_manual_install_commands(behind$package)
    return(invisible())
  }

  # Attempt automatic install
  tryCatch(
    {
      pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
      pak::pkg_install(behind$package, ask = FALSE)
      cli::cli_alert_success("Successfully updated {nrow(behind)} package{?s}")
    },
    error = function(e) {
      cli::cli_alert_danger("Automatic update failed: {conditionMessage(e)}")
      cli::cat_line()
      show_manual_install_commands(behind$package)
    }
  )

  invisible()
}

show_manual_install_commands <- function(packages) {
  cli::cli_alert_info("Run these commands to update manually:")
  cli::cat_line()
  cli::cat_line("pak::repo_add(glycoverse = \"https://glycoverse.r-universe.dev\")")
  pkg_str <- paste0(deparse(packages), collapse = "\n")
  cli::cat_line("pak::pkg_install(", pkg_str, ")")
}

#' Get a situation report on the glycoverse
#'
#' This function gives a quick overview of the versions of R and RStudio as
#' well as all glycoverse packages. It's primarily designed to help you get
#' a quick idea of what's going on when you're helping someone else debug
#' a problem.
#'
#' @export
glycoverse_sitrep <- function() {
  cli::cat_rule("R & RStudio")
  if (rstudioapi::isAvailable()) {
    cli::cat_bullet("RStudio: ", rstudioapi::getVersion())
  }
  cli::cat_bullet("R: ", getRversion())

  deps <- glycoverse_deps()
  package_pad <- format(deps$package)
  packages <- ifelse(
    deps$behind,
    paste0(
      cli::col_yellow(cli::style_bold(package_pad)),
      " (",
      deps$local,
      " < ",
      deps$upstream,
      ")"
    ),
    paste0(
      cli::col_blue(package_pad),
      " (",
      highlight_version(deps$local),
      ")"
    )
  )

  names(packages) <- deps$package

  cli::cat_rule("Core packages")
  cli::cat_bullet(packages[core[core %in% deps$package]])
  cli::cat_rule("Non-core packages")
  cli::cat_bullet(packages[non_core[non_core %in% deps$package]])
}

#' List all glycoverse dependencies
#'
#' @param recursive If \code{TRUE}, will also list all dependencies of
#'   glycoverse packages.
#' @param repos The repositories to use to check for updates.
#'   Defaults to \code{getOption("repos")}.
#' @export
glycoverse_deps <- function(recursive = FALSE, repos = getOption("repos")) {
  if (identical(repos, getOption("repos")) || all(repos == "@CRAN@")) {
    if (requireNamespace("BiocManager", quietly = TRUE)) {
      repos <- BiocManager::repositories()
    }
  }

  repos <- repos[repos != ""]
  if (length(repos) == 0 || all(repos == "@CRAN@")) {
    repos <- c(CRAN = "https://cloud.r-project.org")
  }
  repos[repos == "@CRAN@"] <- "https://cloud.r-project.org"

  installed_pkgs <- utils::installed.packages()
  deps <- tools::package_dependencies("glycoverse", installed_pkgs, recursive = recursive)
  pkg_deps <- unique(c(unlist(deps), core, non_core))
  pkg_deps <- sort(pkg_deps)

  base_pkgs <- c(
    "base", "compiler", "datasets", "graphics", "grDevices", "grid",
    "methods", "parallel", "splines", "stats", "stats4", "tools", "tcltk", "utils"
  )
  pkg_deps <- setdiff(pkg_deps, base_pkgs)

  tool_pkgs <- c("cli", "rstudioapi")
  pkg_deps <- setdiff(pkg_deps, tool_pkgs)

  # Filter non-core packages to only include installed ones
  non_core_installed <- non_core[non_core %in% installed_pkgs]
  pkg_deps <- c(
    intersect(pkg_deps, core),
    non_core_installed,
    setdiff(pkg_deps, c(core, non_core))
  )

  # Get r-universe package versions
  runiverse_pkgs <- runiverse_packages()
  glycoverse_pkgs <- intersect(pkg_deps, names(runiverse_pkgs))
  other_pkgs <- setdiff(pkg_deps, glycoverse_pkgs)

  upstream <- stats::setNames(rep(NA_character_, length(pkg_deps)), pkg_deps)

  # Fill in r-universe versions
  upstream[glycoverse_pkgs] <- runiverse_pkgs[glycoverse_pkgs]

  # Fill in CRAN/Bioconductor versions for other packages
  available <- NULL
  if (length(other_pkgs) > 0) {
    available <- suppressWarnings(
      tryCatch(
        utils::available.packages(repos = repos),
        error = function(...) NULL
      )
    )

    if (!is.null(available) && nrow(available) > 0) {
      upstream[other_pkgs] <- vapply(
        other_pkgs,
        function(pkg) {
          if (!pkg %in% rownames(available)) {
            return(NA_character_)
          }
          v <- available[pkg, "Version"]
          if (is.null(v) || length(v) == 0 || is.na(v)) NA_character_ else v
        },
        character(1)
      )
    }
  }

  local_version <- lapply(pkg_deps, safe_package_version)

  behind <- purrr::map2_lgl(
    upstream,
    local_version,
    function(up, loc) {
      if (is.na(up) || up == "") {
        FALSE
      } else {
        numeric_version(up) > loc
      }
    }
  )

  pkg_sources <- stats::setNames(rep("cran", length(pkg_deps)), pkg_deps)
  pkg_sources[glycoverse_pkgs] <- "runiverse"
  if (!is.null(available)) {
    for (pkg in intersect(other_pkgs, rownames(available))) {
      repo <- available[pkg, "Repository"]
      if (grepl("bioconductor.org", repo)) {
        pkg_sources[pkg] <- "bioconductor"
      }
    }
  }

  tibble::tibble(
    package = pkg_deps,
    source = as.character(pkg_sources),
    upstream = upstream,
    local = purrr::map_chr(local_version, as.character),
    behind = behind
  )
}

safe_package_version <- function(pkg) {
  if (rlang::is_installed(pkg)) {
    utils::packageVersion(pkg)
  } else {
    package_version("0.0.0")
  }
}

runiverse_packages <- function() {
  url <- "https://glycoverse.r-universe.dev/packages"

  old <- options(HTTPUserAgent = "glycoverse (https://github.com/glycoverse/glycoverse)")
  on.exit(options(old), add = TRUE)

  response <- suppressWarnings(
    tryCatch(
      jsonlite::fromJSON(url),
      error = function(...) NULL
    )
  )

  if (is.null(response) || nrow(response) == 0) {
    return(character())
  }

  stats::setNames(response$Version, response$Package)
}

runiverse_version <- function(pkg, all_pkgs = NULL) {
  if (is.null(all_pkgs)) {
    all_pkgs <- runiverse_packages()
  }

  if (length(all_pkgs) == 0 || !pkg %in% names(all_pkgs)) {
    return(NA_character_)
  }

  all_pkgs[[pkg]]
}
