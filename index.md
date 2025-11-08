# glycoverse

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

## Important Note

`glycoverse` before v0.1.1 had serious bugs in dependency management. We
recommend all users to update to the latest version of `glycoverse`, and
call
[`glycoverse::glycoverse_update()`](https://glycoverse.github.io/glycoverse/reference/glycoverse_update.md)
to update all the packages in the `glycoverse` ecosystem.

Besides, we are progressively uploading glycoverse packages to CRAN.
Every time a package is shifted to CRAN, we will update the `glycoverse`
meta-package to depend on the CRAN version of that package. So come back
from time to time to check if you have the latest version of
`glycoverse`!

## Documentation

We have two case studies that showcase the basic workflow of
`glycoverse`:

- [Case Study:
  Glycoproteomics](https://glycoverse.github.io/glycoverse/articles/case-study-1.html)
- [Case Study:
  Glycomics](https://glycoverse.github.io/glycoverse/articles/case-study-2.html)

Choose one of them to get started, and then refer to the documentation
of the individual packages for more details.

## Usage

[`library(glycoverse)`](https://glycoverse.github.io/glycoverse/) will
load all the core packages in the `glycoverse` ecosystem:

This includes:

**Omics data analysis**

- [glyexp](https://glycoverse.github.io/glyexp/), for data management
- [glyread](https://glycoverse.github.io/glyread/), for data import
- [glyclean](https://glycoverse.github.io/glyclean/), for data cleaning
  and preprocessing
- [glystats](https://glycoverse.github.io/glystats/), for statistical
  analysis
- [glyvis](https://glycoverse.github.io/glyvis/), for data visualization

**Glycan structure analysis**

- [glyrepr](https://glycoverse.github.io/glyrepr/), for glycan structure
  representation
- [glyparse](https://glycoverse.github.io/glyparse/), for glycan
  structure parsing
- [glymotif](https://glycoverse.github.io/glymotif/), for glycan
  structure motif analysis
- [glydet](https://glycoverse.github.io/glydet/), for glycan derived
  trait analysis
- [glyenzy](https://glycoverse.github.io/glyenzy/), for glycan
  biosynthesis pathway analysis

You also get a condensed summary of conflicts with other packages you
have loaded:

``` r
library(glycoverse)
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.1.3.9000 ──
#> ✔ glyclean 0.8.1      ✔ glyparse 0.5.3 
#> ✔ glydet   0.6.5      ✔ glyread  0.8.2 
#> ✔ glyenzy  0.4.1      ✔ glyrepr  0.7.5 
#> ✔ glyexp   0.10.1     ✔ glystats 0.5.3 
#> ✔ glymotif 0.11.2     ✔ glyvis   0.4.0 
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

And you can update all the packages with
[`glycoverse_update()`](https://glycoverse.github.io/glycoverse/reference/glycoverse_update.md):

``` r
glycoverse_update()
#> The following package is out of date:
#> 
#> • purrr (1.1.0 -> 1.2.0)
#> 
#> Start a clean R session then run:
#> install.packages("purrr")
```
