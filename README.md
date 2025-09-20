
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
-   [glyenzy](https://glycoverse.github.io/glyenzy/), for glycan
    biosynthesis pathway analysis

You also get a condensed summary of conflicts with other packages you
have loaded:

``` r
library(glycoverse)
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.0.0.9000 ──
#> ✔ glyclean 0.6.4     ✔ glyparse 0.4.4
#> ✔ glydet   0.3.0     ✔ glyread  0.6.1
#> ✔ glyenzy  0.2.2     ✔ glyrepr  0.7.3
#> ✔ glyexp   0.9.1     ✔ glystats 0.4.2
#> ✔ glymotif 0.8.0     ✔ glyvis   0.1.2
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

And you can update all the packages with `glycoverse_update()`:

``` r
glycoverse_update()
#> All glycoverse packages up-to-date
```
