# Update glycoverse packages

This checks r-universe for all glycoverse packages (and optionally,
their dependencies) and reports which ones have newer versions
available. You can then choose to update automatically or get manual
instructions.

## Usage

``` r
glycoverse_update(
  recursive = FALSE,
  repos = getOption("repos"),
  dev_to_latest = NULL
)
```

## Arguments

- recursive:

  If `TRUE`, will also list all dependencies of glycoverse packages.

- repos:

  The repositories to use to check for updates. Defaults to
  `getOption("repos")`.

- dev_to_latest:

  If `TRUE`, replace development versions (versions with a 4th component
  \>= 9000, e.g., `0.1.0.9000`) with the latest release versions. If
  `FALSE`, keep development versions as-is. If `NULL` (the default), and
  in interactive mode, the user will be prompted. In non-interactive
  mode, `NULL` defaults to `FALSE`.

## Examples

``` r
if (FALSE) { # \dontrun{
glycoverse_update()
} # }
```
