
<!-- README.md is generated from README.Rmd. Please edit that file -->

# glycoverse <a href="https://glycoverse.github.io/glycoverse/"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/glycoverse)](https://CRAN.R-project.org/package=glycoverse)
[![R-CMD-check](https://github.com/glycoverse/glycoverse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/glycoverse/glycoverse/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/glycoverse/glycoverse/graph/badge.svg)](https://app.codecov.io/gh/glycoverse/glycoverse)
<!-- badges: end -->

The ‘glycoverse’ is a set of packages that together form a comprehensive
pipeline for glycomics and glycoproteomics data analysis. This package
is designed to make it easy to install and load multiple ‘glycoverse’
packages in a single step.

## Installation

You can install the latest release of glycoverse core packages from
[r-universe](https://glycoverse.r-universe.dev/glycoverse)
(**recommended**) with:

``` r
# install.packages("pak")
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse")
```

Or from [GitHub](https://github.com/glycoverse/glycoverse):

``` r
pak::pkg_install("glycoverse/glycoverse@*release")
```

Or install the development version (NOT recommended):

``` r
pak::pkg_install("glycoverse/glycoverse")
```

Just like `tidyverse`, installing `glycoverse` automatically installs
all glycoverse core packages including `glyexp`, `glyread`, `glyclean`,
`glystats`, `glyvis`, `glyrepr`, `glyparse`, `glymotif`, `glydet`, and
`glydraw`.

You can also only install some of them manually if you don’t want the
whole repertoire. For example:

``` r
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glymotif")
```

Note that `glymotif` depends on `glyexp`, `glyrepr` and `glyparse`, so
these three packages will also be installed.

## Important Note

`glycoverse` before v0.2.5 used GitHub releases instead of r-universe
releases. We recommend all users to update the meta-package `glycoverse`
to the latest version for better package update experience.

``` r
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse")
```

## Documentation

We have two case studies that showcase the basic workflow of
`glycoverse`:

-   [Case Study:
    Glycoproteomics](https://glycoverse.github.io/glycoverse/articles/case-study-1.html)
-   [Case Study:
    Glycomics](https://glycoverse.github.io/glycoverse/articles/case-study-2.html)

Choose one of them to get started, and then refer to the documentation
of the individual packages for more details.

## Usage

`library(glycoverse)` will load all the core packages in the
`glycoverse` ecosystem:

``` r
library(glycoverse)
#> Warning: 程序包'glyread'是用R版本4.5.2 来建造的
#> Warning: 程序包'glyrepr'是用R版本4.5.2 来建造的
#> Warning: 程序包'glydraw'是用R版本4.5.2 来建造的
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.2.4.9000 ──
#> ✔ glyclean 0.12.1     ✔ glyparse 0.5.5 
#> ✔ glydet   0.10.2     ✔ glyread  0.9.1 
#> ✔ glydraw  0.3.1      ✔ glyrepr  0.10.0
#> ✔ glyexp   0.12.4     ✔ glystats 0.6.5 
#> ✔ glymotif 0.13.1     ✔ glyvis   0.5.1 
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

This includes:

**Omics data analysis**

-   [glyexp](https://glycoverse.github.io/glyexp/), for data management
-   [glyread](https://glycoverse.github.io/glyread/), for data import
-   [glyclean](https://glycoverse.github.io/glyclean/), for data
    cleaning and preprocessing
-   [glystats](https://glycoverse.github.io/glystats/), for statistical
    analysis
-   [glyvis](https://glycoverse.github.io/glyvis/), for data
    visualization

**Glycan structure analysis**

-   [glyrepr](https://glycoverse.github.io/glyrepr/), for glycan
    structure representation
-   [glyparse](https://glycoverse.github.io/glyparse/), for glycan
    structure parsing
-   [glymotif](https://glycoverse.github.io/glymotif/), for glycan
    structure motif analysis
-   [glydet](https://glycoverse.github.io/glydet/), for glycan derived
    trait analysis
-   [glydraw](https://glycoverse.github.io/glydraw/), for glycan
    structure visualization

You can also install the non-core glycoverse packages if needed:

-   [glyenzy](https://glycoverse.github.io/glyenzy/), for glycan
    biosynthesis pathway analysis
-   [glydb](https://glycoverse.github.io/glydb/), for glycan database
-   [glyanno](https://glycoverse.github.io/glyanno/), for glycan
    annotation
-   [glysmith](https://glycoverse.github.io/glysmith/), for full
    analytical pipeline

You can get a situation report of all the packages in the `glycoverse`
ecosystem with `glycoverse_sitrep()`:

``` r
glycoverse_sitrep()
#> ── R & RStudio ─────────────────────────────────────────────────────────────────
#> • R: 4.5.1
#> 'getOption("repos")' replaces Bioconductor standard repositories, see
#> 'help("repositories", package = "BiocManager")' for details.
#> Replacement repositories:
#>     CRAN: https://cloud.r-project.org
#> ── Core packages ───────────────────────────────────────────────────────────────
#> • glyexp      (0.12.4)
#> • glyread     (0.9.1)
#> • glyclean    (0.12.1)
#> • glystats    (0.6.5)
#> • glyvis      (0.5.1)
#> • glyrepr     (0.10.0)
#> • glyparse    (0.5.5)
#> • glymotif    (0.13.1)
#> • glydet      (0.10.2)
#> • glydraw     (0.3.1)
#> ── Non-core packages ───────────────────────────────────────────────────────────
#> • glyenzy     (0.4.3)
#> • glydb       (0.3.3)
#> • glyanno     (0.1.2)
#> • glysmith    (0.9.1)
```

To list all dependencies of glycoverse core packages, run:

``` r
glycoverse_deps(recursive = TRUE)  # recursive = TRUE to list dependencies of each package
#> 'getOption("repos")' replaces Bioconductor standard repositories, see
#> 'help("repositories", package = "BiocManager")' for details.
#> Replacement repositories:
#>     CRAN: https://cloud.r-project.org
#> # A tibble: 127 × 5
#>    package  source    upstream local  behind
#>    <chr>    <chr>     <chr>    <chr>  <lgl> 
#>  1 glyclean runiverse 0.12.1   0.12.1 FALSE 
#>  2 glydet   runiverse 0.10.2   0.10.2 FALSE 
#>  3 glydraw  runiverse 0.3.1    0.3.1  FALSE 
#>  4 glyexp   runiverse 0.12.4   0.12.4 FALSE 
#>  5 glymotif runiverse 0.13.1   0.13.1 FALSE 
#>  6 glyparse runiverse 0.5.5    0.5.5  FALSE 
#>  7 glyread  runiverse 0.9.1    0.9.1  FALSE 
#>  8 glyrepr  runiverse 0.10.0   0.10.0 FALSE 
#>  9 glystats runiverse 0.6.5    0.6.5  FALSE 
#> 10 glyvis   runiverse 0.5.1    0.5.1  FALSE 
#> # ℹ 117 more rows
```

And you can update all the packages with `glycoverse_update()`:

``` r
glycoverse_update()
```
