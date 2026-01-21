
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

You can install the latest release of glycoverse from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("glycoverse/glycoverse@*release")
```

Or install the development version:

``` r
remotes::install_github("glycoverse/glycoverse")
```

### Troubleshooting

We have scheduled to upload glycoverse packages to CRAN or Bioconductor,
but for now, many glycoverse packages (including this meta-package) can
only be install from GitHub.

Installing R packages from GitHub can be tricky. If you encounter any
problem installing the packages, google “install R package from github”
might help.

Here are some common situations encountered by our colleagues:

**1. If you’re using `pak` and failed.**

`pak` currently cannot handle building from source properly on some
machines. Try using `remotes::install_github()` or
`devtools::install_github()`.

**2. If you’re using `remotes` or `devtools` and failed.**

**2.1 Rtools not installed**

    Could not find tools necessary to compile a package
    Call `pkgbuild::check_build_tools(debug = TRUE)` to diagnose the problem.

It means `Rtools` is not installed. Calling
`pkgbuild::check_build_tools(debug = TRUE)` will install `Rtools` for
you automatically. If not,
[download](https://cran.r-project.org/bin/windows/Rtools/) and install
it manually.

**2.2 HTTP error 403**

    HTTP error 403.
      API rate limit exceeded for xxx.xxx.xxx.xxx. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)

      Rate limit remaining: 0/60
      Rate limit reset at: 2026-01-21 07:58:19 UTC

      To increase your GitHub API rate limit
      - Use `usethis::create_github_token()` to create a Personal Access Token.
      - Use `gitcreds::gitcreds_set()` to add the token.

If so, following the instruction to create and set a Personal Access
Token. You need to have a GitHub account and `Git` installed locally as
prerequisites.

## Important Note

`glycoverse` before v0.1.1 had serious bugs in dependency management. We
recommend all users to update to the latest version of `glycoverse`, and
call `glycoverse::glycoverse_update()` to update all the packages in the
`glycoverse` ecosystem.

Besides, we are progressively uploading glycoverse packages to CRAN.
Every time a package is shifted to CRAN, we will update the `glycoverse`
meta-package to depend on the CRAN version of that package. So come back
from time to time to check if you have the latest version of
`glycoverse`!

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
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.2.3.9000 ──
#> ✔ glyclean 0.12.0          ✔ glyparse 0.5.3.9000 
#> ✔ glydet   0.9.0           ✔ glyread  0.8.4      
#> ✔ glydraw  0.2.0           ✔ glyrepr  0.9.0.9000 
#> ✔ glyexp   0.12.3.9000     ✔ glystats 0.6.3      
#> ✔ glymotif 0.12.0          ✔ glyvis   0.5.0      
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
#> • glyexp      (0.12.3.9000)
#> • glyread     (0.8.4)
#> • glyclean    (0.12.0)
#> • glystats    (0.6.3)
#> • glyvis      (0.5.0)
#> • glyrepr     (0.9.0.9000)
#> • glyparse    (0.5.3.9000)
#> • glymotif    (0.12.0)
#> • glydet      (0.9.0)
#> • glydraw     (0.2.0)
#> ── Non-core packages ───────────────────────────────────────────────────────────
#> • glyenzy     (0.4.1)
#> • glydb       (0.3.1.9000)
#> • glyanno     (0.1.0)
#> • glysmith    (0.8.0)
```

To list all dependencies of glycoverse core packages, run:

``` r
glycoverse_deps(recursive = TRUE)  # recursive = TRUE to list dependencies of each package
#> 'getOption("repos")' replaces Bioconductor standard repositories, see
#> 'help("repositories", package = "BiocManager")' for details.
#> Replacement repositories:
#>     CRAN: https://cloud.r-project.org
#> # A tibble: 149 × 6
#>    package       source       remote upstream local   behind
#>    <chr>         <chr>        <chr>  <chr>    <chr>   <lgl> 
#>  1 ade4          cran         <NA>   1.7-23   1.7.23  FALSE 
#>  2 AnnotationDbi bioconductor <NA>   1.72.0   1.72.0  FALSE 
#>  3 askpass       cran         <NA>   1.2.1    1.2.1   FALSE 
#>  4 backports     cran         <NA>   1.5.0    1.5.0   FALSE 
#>  5 base64enc     cran         <NA>   0.1-3    0.1.3   FALSE 
#>  6 Biobase       bioconductor <NA>   2.70.0   2.70.0  FALSE 
#>  7 BiocBaseUtils bioconductor <NA>   1.12.0   1.12.0  FALSE 
#>  8 BiocFileCache bioconductor <NA>   3.0.0    3.0.0   FALSE 
#>  9 BiocGenerics  bioconductor <NA>   0.56.0   0.56.0  FALSE 
#> 10 BiocManager   cran         <NA>   1.30.27  1.30.27 FALSE 
#> # ℹ 139 more rows
```

And you can update all the packages with `glycoverse_update()`:

``` r
glycoverse_update()
```
