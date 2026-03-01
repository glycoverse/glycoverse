# Conflicts between the glycoverse and other packages

This function lists all the conflicts between packages in the glycoverse
and other packages that you have loaded.

## Usage

``` r
glycoverse_conflicts(only = NULL)
```

## Arguments

- only:

  Set this to a character vector to restrict to conflicts only with
  these packages.

## Details

There are four conflicts that are deliberately ignored: `intersect`,
`union`, `setequal`, and `setdiff` from dplyr. These functions make the
base equivalents generic, so shouldn't negatively affect any existing
code.

## Examples

``` r
glycoverse_conflicts()
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```
