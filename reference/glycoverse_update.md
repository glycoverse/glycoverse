# Update glycoverse packages

This checks r-universe for all glycoverse packages (and optionally,
their dependencies) and reports which ones have newer versions
available. You can then choose to update automatically or get manual
instructions.

## Usage

``` r
glycoverse_update(recursive = FALSE, repos = getOption("repos"))
```

## Arguments

- recursive:

  If `TRUE`, will also list all dependencies of glycoverse packages.

- repos:

  The repositories to use to check for updates. Defaults to
  `getOption("repos")`.

## Examples

``` r
if (FALSE) { # \dontrun{
glycoverse_update()
} # }
```
