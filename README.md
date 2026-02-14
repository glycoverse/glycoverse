
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

The word `glycoverse` has two meanings:

1.  The `glycoverse` ecosystem refers to a set of packages that together
    form a comprehensive pipeline for glycomics and glycoproteomics data
    analysis, including `glyrepr`, `glyexp`, etc.
2.  The `glycoverse` meta-package is a meta-package that helps manage
    glycoverse packages (installation, update, and status check).

This repository is for the `glycoverse` meta-package.

## Installation

### Install from r-universe

You can install the latest release of glycoverse core packages from
[r-universe](https://glycoverse.r-universe.dev/glycoverse)
(**recommended**) with:

``` r
# install.packages("pak")
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse")
```

This will install the meta-package `glycoverse`, as well as all
glycoverse core packages, including `glyexp`, `glyread`, `glyclean`,
`glystats`, `glyvis`, `glyrepr`, `glyparse`, `glymotif`, `glydet`, and
`glydraw`.

**Troubleshooting:** If you encounter a “Failed to download xxx” or
“403” error, it is likely a network issue. R-universe has strict rate
limiting (or access controls). Try switching your network environment or
installing directly from GitHub.

Note that you can also install packages individually:

``` r
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")  # you only need to run this once in a session
pak::pkg_install("glymotif")  # this will also install glyrepr, glyparse, and glyexp
```

### Install from GitHub

**Prerequisite:** To install packages from GitHub, you’ll need the
proper compilation tools installed on your system. This means
[RTools](https://cran.r-project.org/bin/windows/Rtools/) for Windows and
[Xcode Command Line
Tools](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools)
for macOS. Without them, you’ll likely see a “Could not find tools
necessary to compile a package” error. If you’re unsure about the
process, a quick search for “install R package from GitHub” will provide
helpful context on why these tools are necessary.

Installing from [GitHub](https://github.com/glycoverse/glycoverse) is a
little tricky. Package dependencies within glycoverse are resolved
assuming all packages are on r-universe (some on CRAN or Bioconductor).
It means that when running the following code:

``` r
# Do NOT run:
pak::pkg_install("glycoverse/glyxxx@*release")  # common practice to install a GitHub package
```

Installing glyxxx from GitHub in this way does not bypass R-universe
entirely, as its dependencies are still hosted there. If you are
experiencing network issues with R-universe, switching to the GitHub
version of glyxxx will not resolve the problem.

To truely install a glycoverse package from GitHub (along with all its
dependencies), you have to install them one by one following the
dependency tree:

``` r
pak::pkg_install("glyrepr")  # from CRAN
pak::pkg_install("glyparse")  # from CRAN
pak::pkg_install("glycoverse/glyexp@*release")
pak::pkg_install("glycoverse/glydraw@*release")
pak::pkg_install("glycoverse/glyread@*release")
pak::pkg_install("glycoverse/glyclean@*release")
pak::pkg_install("glycoverse/glystats@*release")
pak::pkg_install("glycoverse/glymotif@*release")
pak::pkg_install("glycoverse/glyvis@*release")
pak::pkg_install("glycoverse/glydet@*release")

# The meta-package
pak::pkg_install("glycoverse/glycoverse@*release")
```

**Note:** Check the DESCRIPTION file of each package to find its
dependencies.

**Troubleshooting:** Encountering an “HTTP error 403”? This usually
means your IP has been rate-limited by GitHub. To resolve this, you need
to configure a Personal Access Token (PAT).

1.  Sign up for a [GitHub](https://github.com) account.
2.  Install [Git](https://git-scm.com) on your local machine.
3.  Generate a PAT via your GitHub settings.
4.  Configure the PAT locally (e.g., using the `gitcreds` R package).

For a step-by-step guide, search for “How to set up GitHub PAT for R.”

### Install optional packages

`glydb`, `glyanno`, `glyenzy` and `glysmith` are not bundled with the
meta-package `glycoverse`. You need to install them seperately via
r-universe or GitHub.

## Important Note

`glycoverse` before v0.2.5 used GitHub releases instead of r-universe
releases. We recommend all users to update the meta-package `glycoverse`
to the latest version for better package update experience.

``` r
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse")
```

## Learning glycoverse

If you want an out-of-box data analysis experience, learn
[glyexp](https://glycoverse.github.io/glyexp/) and
[glyread](https://glycoverse.github.io/glyread/), then try
[glysmith](https://glycoverse.github.io/glysmith/).

If you want to learn glycoverse systematically, first checkout one of
the following case studies that showcase the basic workflow of
`glycoverse`:

-   [Case Study:
    Glycoproteomics](https://glycoverse.github.io/glycoverse/articles/case-study-1.html)
-   [Case Study:
    Glycomics](https://glycoverse.github.io/glycoverse/articles/case-study-2.html)

Then refer to the documentation of the individual packages for more
details.

We recommend the following learning order for regular omics data
analysis:

[glyexp](https://glycoverse.github.io/glyexp/) (**very important**) ->
[glyread](https://glycoverse.github.io/glyread/) ->
[glyclean](https://glycoverse.github.io/glyclean/) ->
[glystats](https://glycoverse.github.io/glystats/) ->
[glyvis](https://glycoverse.github.io/glyvis/)

If you’re dealing with glycan structures, learn these additional
packages:

[glyrepr](https://glycoverse.github.io/glyrepr/) (**very important**) ->
[glyparse](https://glycoverse.github.io/glyparse/) ->
[glymotif](https://glycoverse.github.io/glymotif/) ->
[glydet](https://glycoverse.github.io/glydet/) ->
[glydraw](https://glycoverse.github.io/glydraw/)

You will also find [glydb](https://glycoverse.github.io/glydb/) and
[glyanno](https://glycoverse.github.io/glyanno/) very useful, if your
glycan compositions or structures are in low resolution.

## Usage

`library(glycoverse)` will load all the core packages in the
`glycoverse` ecosystem:

``` r
library(glycoverse)
#> Warning: 程序包'glyread'是用R版本4.5.2 来建造的
#> Warning: 程序包'glyrepr'是用R版本4.5.2 来建造的
#> Warning: 程序包'glydraw'是用R版本4.5.2 来建造的
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.2.5.9000 ──
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
#> • glyrepr     (0.10.0 < 0.10.1)
#> • glyparse    (0.5.5)
#> • glymotif    (0.13.1)
#> • glydet      (0.10.2)
#> • glydraw     (0.3.1)
#> ── Non-core packages ───────────────────────────────────────────────────────────
#> • glyenzy     (0.4.3)
#> • glydb       (0.4.0)
#> • glyanno     (0.1.2 < 0.2.0)
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
#>  8 glyrepr  runiverse 0.10.1   0.10.0 TRUE  
#>  9 glystats runiverse 0.6.5    0.6.5  FALSE 
#> 10 glyvis   runiverse 0.5.1    0.5.1  FALSE 
#> # ℹ 117 more rows
```

And you can update all the packages with `glycoverse_update()`:

``` r
glycoverse_update()
```
