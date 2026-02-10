# glycoverse

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

`glycoverse` before v0.1.1 had serious bugs in dependency management. We
recommend all users to update to the latest version of `glycoverse`, and
call
[`glycoverse::glycoverse_update()`](https://glycoverse.github.io/glycoverse/reference/glycoverse_update.md)
to update all the packages in the `glycoverse` ecosystem.

Besides, we are progressively uploading glycoverse packages to CRAN or
Bioconductor. Every time a package is shifted to CRAN/Bioconductor, we
will update the `glycoverse` meta-package to depend on the
CRAN/Bioconductor version of that package. So come back from time to
time to check if you have the latest version of `glycoverse`!

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

``` r
library(glycoverse)
#> Warning: 程序包'glyread'是用R版本4.5.2 来建造的
#> Warning: 程序包'glyrepr'是用R版本4.5.2 来建造的
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.2.4.9000 ──
#> ✔ glyclean 0.12.0     ✔ glyparse 0.5.5 
#> ✔ glydet   0.10.1     ✔ glyread  0.9.0 
#> ✔ glydraw  0.3.1      ✔ glyrepr  0.10.0
#> ✔ glyexp   0.12.4     ✔ glystats 0.6.4 
#> ✔ glymotif 0.13.0     ✔ glyvis   0.5.0 
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

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
- [glydraw](https://glycoverse.github.io/glydraw/), for glycan structure
  visualization

You can also install the non-core glycoverse packages if needed:

- [glyenzy](https://glycoverse.github.io/glyenzy/), for glycan
  biosynthesis pathway analysis
- [glydb](https://glycoverse.github.io/glydb/), for glycan database
- [glyanno](https://glycoverse.github.io/glyanno/), for glycan
  annotation
- [glysmith](https://glycoverse.github.io/glysmith/), for full
  analytical pipeline

You can get a situation report of all the packages in the `glycoverse`
ecosystem with
[`glycoverse_sitrep()`](https://glycoverse.github.io/glycoverse/reference/glycoverse_sitrep.md):

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
#> • glyread     (0.9.0)
#> • glyclean    (0.12.0)
#> • glystats    (0.6.4)
#> • glyvis      (0.5.0)
#> • glyrepr     (0.10.0)
#> • glyparse    (0.5.5)
#> • glymotif    (0.13.0)
#> • glydet      (0.10.1)
#> • glydraw     (0.3.1)
#> ── Non-core packages ───────────────────────────────────────────────────────────
#> • glyenzy     (0.4.2)
#> • glydb       (0.3.2 < 0.3.3)
#> • glyanno     (0.1.1)
#> • glysmith    (0.8.1 < 0.9.0)
```

To list all dependencies of glycoverse core packages, run:

``` r
glycoverse_deps(recursive = TRUE)  # recursive = TRUE to list dependencies of each package
#> 'getOption("repos")' replaces Bioconductor standard repositories, see
#> 'help("repositories", package = "BiocManager")' for details.
#> Replacement repositories:
#>     CRAN: https://cloud.r-project.org
#> # A tibble: 127 × 6
#>    package  source remote                       upstream local  behind
#>    <chr>    <chr>  <chr>                        <chr>    <chr>  <lgl> 
#>  1 glyclean github glycoverse/glyclean@*release 0.12.0   0.12.0 FALSE 
#>  2 glydet   github glycoverse/glydet@*release   0.10.1   0.10.1 FALSE 
#>  3 glydraw  github glycoverse/glydraw@*release  0.3.1    0.3.1  FALSE 
#>  4 glyexp   github glycoverse/glyexp@*release   0.12.4   0.12.4 FALSE 
#>  5 glymotif github glycoverse/glymotif@*release 0.13.0   0.13.0 FALSE 
#>  6 glyparse github glycoverse/glyparse@*release 0.5.5    0.5.5  FALSE 
#>  7 glyread  github glycoverse/glyread@*release  0.9.0    0.9.0  FALSE 
#>  8 glyrepr  github glycoverse/glyrepr@*release  0.10.0   0.10.0 FALSE 
#>  9 glystats github glycoverse/glystats@*release 0.6.4    0.6.4  FALSE 
#> 10 glyvis   github glycoverse/glyvis@*release   0.5.0    0.5.0  FALSE 
#> # ℹ 117 more rows
```

And you can update all the packages with
[`glycoverse_update()`](https://glycoverse.github.io/glycoverse/reference/glycoverse_update.md):

``` r
glycoverse_update()
```
