
<!-- README.md is generated from README.Rmd. Please edit that file -->

<div align="center">

<img src="man/figures/logo.png" height="150" alt="glycoverse logo" />

# glycoverse

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-universe
version](https://glycoverse.r-universe.dev/glycoverse/badges/version)](https://glycoverse.r-universe.dev/glycoverse)
[![R-CMD-check](https://github.com/glycoverse/glycoverse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/glycoverse/glycoverse/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/glycoverse/glycoverse/graph/badge.svg)](https://app.codecov.io/gh/glycoverse/glycoverse)
<!-- badges: end -->

**Glyco-Omics Data Analysis Made Easy**

</div>

## Overview

`glycoverse` is a comprehensive R ecosystem designed for glycomics and
glycoproteomics data analysis. It provides a unified pipeline that
covers the entire analytical workflow, from data import and cleaning to
statistical analysis and visualization. It also provides a dedicated
infrastructure for glycan structure analysis.

### Core Packages

The glycoverse ecosystem is organized into two main categories:

**Omics Data Analysis**

| Package                                            | Description                            |
|----------------------------------------------------|----------------------------------------|
| [glyexp](https://glycoverse.github.io/glyexp/)     | Data management and experiment objects |
| [glyread](https://glycoverse.github.io/glyread/)   | Data import from various sources       |
| [glyclean](https://glycoverse.github.io/glyclean/) | Data cleaning and preprocessing        |
| [glystats](https://glycoverse.github.io/glystats/) | Statistical analysis                   |
| [glyvis](https://glycoverse.github.io/glyvis/)     | Data visualization                     |

**Glycan Structure Analysis**

| Package                                            | Description                     |
|----------------------------------------------------|---------------------------------|
| [glyrepr](https://glycoverse.github.io/glyrepr/)   | Glycan structure representation |
| [glyparse](https://glycoverse.github.io/glyparse/) | Glycan structure parsing        |
| [glymotif](https://glycoverse.github.io/glymotif/) | Motif analysis                  |
| [glydet](https://glycoverse.github.io/glydet/)     | Derived trait analysis          |
| [glydraw](https://glycoverse.github.io/glydraw/)   | Structure visualization         |

### Optional Packages

| Package                                            | Description                   |
|----------------------------------------------------|-------------------------------|
| [glydb](https://glycoverse.github.io/glydb/)       | Glycan database               |
| [glyanno](https://glycoverse.github.io/glyanno/)   | Glycan annotation             |
| [glyenzy](https://glycoverse.github.io/glyenzy/)   | Biosynthesis pathway analysis |
| [glysmith](https://glycoverse.github.io/glysmith/) | Full analytical pipeline      |

### glycoverse Meta-Package

This repository contains the `glycoverse` meta-package, which provides
convenient tools for managing the entire glycoverse ecosystem:

-   **One-command installation**: Install all core packages at once
-   **Package updates**: Update all glycoverse packages with a single
    function
-   **Situation report**: Check the status of all installed glycoverse
    packages

## Installation

### Install from r-universe (Recommended)

``` r
# install.packages("pak")
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glycoverse")
```

This installs the meta-package and all core packages: `glyexp`,
`glyread`, `glyclean`, `glystats`, `glyvis`, `glyrepr`, `glyparse`,
`glymotif`, `glydet`, and `glydraw`.

**Troubleshooting:** “Failed to download” or “403” errors usually
indicate network issues with r-universe rate limiting. Try switching
network environments or installing from GitHub.

### Install Individual Packages

``` r
pak::repo_add(glycoverse = "https://glycoverse.r-universe.dev")
pak::pkg_install("glymotif")  # Also installs dependencies: glyrepr, glyparse, glyexp
```

### Install from GitHub

<details>
<summary>
Click to expand detailed GitHub installation instructions
</summary>

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

</details>

### Install optional packages

`glydb`, `glyanno`, `glyenzy`, and `glysmith` are installed separately:

``` r
pak::pkg_install("glydb")
pak::pkg_install("glyanno")
```

## Getting Started

### Quick Start

Load all core packages:

``` r
library(glycoverse)
#> Warning: 程序包'glyexp'是用R版本4.5.3 来建造的
#> Warning: 程序包'glyread'是用R版本4.5.3 来建造的
#> Warning: 程序包'glyclean'是用R版本4.5.2 来建造的
#> Warning: 程序包'glyrepr'是用R版本4.5.2 来建造的
#> Warning: 程序包'glydet'是用R版本4.5.3 来建造的
#> ── Attaching core glycoverse packages ───────────────── glycoverse 0.3.0.9000 ──
#> ✔ glyclean 0.12.2         ✔ glyparse 0.5.7     
#> ✔ glydet   0.10.4         ✔ glyread  0.9.1     
#> ✔ glydraw  0.3.1.9000     ✔ glyrepr  0.10.1    
#> ✔ glyexp   0.14.0         ✔ glystats 0.6.5     
#> ✔ glymotif 0.13.1         ✔ glyvis   0.5.1     
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate() masks stats::aggregate()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Check your installation:

``` r
glycoverse_sitrep()
```

### Learning Path

**For out-of-box analysis:** Start with
[glyexp](https://glycoverse.github.io/glyexp/) →
[glyread](https://glycoverse.github.io/glyread/) →
[glysmith](https://glycoverse.github.io/glysmith/)

**For systematic learning:**

1.  Read the case studies:
    -   [Glycoproteomics
        Analysis](https://glycoverse.github.io/glycoverse/articles/case-study-1.html)
    -   [Glycomics
        Analysis](https://glycoverse.github.io/glycoverse/articles/case-study-2.html)
2.  Follow the recommended learning order:
    -   Omics: glyexp → glyread → glyclean → glystats → glyvis
    -   Structures: glyrepr → glyparse → glymotif → glydet → glydraw

### Updating Packages

``` r
# Update all glycoverse packages
glycoverse_update()

# List all dependencies
glycoverse_deps(recursive = TRUE)
```

## Important Notes

-   glycoverse v0.2.5+ uses r-universe for releases. Update the
    meta-package for better package management.
-   Updating the meta-package itself does not automatically update other
    glycoverse packages. Use `glycoverse_update()` for that.
