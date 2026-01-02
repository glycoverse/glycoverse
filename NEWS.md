# glycoverse (development version)

# glycoverse 0.2.2

## Minor improvements and bug fixes

* Use the release version of glydraw.

# glycoverse 0.2.1

* Remove glysmith from core dependency.

# glycoverse 0.2.0

## New features

* `glycoverse_sitrep()` only checks glycoverse packages now, including a few new packages, i.e., glydraw, glydb, glyanno, glysmith.
* Remove `glyenzy` from glycoverse core packages.
* `glycoverse_update()` now updates glycoverse packages using `pak`, instead of just printing the commands.

## Minor improvements and bug fixes

* Fix the bug that `glycoverse_deps()` raised an error when `recursive` was TRUE.
* Fix the bug that upstream version numbers of Bioconductor dependencies could not be fetched.
* Update all dependencies to their latest versions.
* Add more packages to the end of the case study vignettes.

# glycoverse 0.1.3

* Use the CRAN version of glyparse.

# glycoverse 0.1.2

* Use the CRAN version of glyrepr.

# glycoverse 0.1.1

* Fix a bug in `glycoverse_update()` where the upstream packages were not set correctly (CRAN, instead of GitHub).

# glycoverse 0.1.0

* Initial GitHub release.
