# CRAN submission comments — aemo 0.1.0

## New submission (archived-name reclaim)

This is a new package taking over the `aemo` name, previously
held by Imanuel Costigan's `aemo` package (2014-2020, archived
2021-12-29). The earlier package implemented 3 functions covering
prices and demand only; this rewrite covers the full NEMweb +
MMSDM data surface and shares only the package name.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test suite

Network-dependent tests are wrapped in `skip_on_cran()` and
`skip_if_offline()`. The `AEMO_LIVE_TESTS` environment variable
controls whether optional live-fetch tests run.

## Notes on data access

* All data sources are public and free. No authentication.
* Downloaded data is cached to `tools::R_user_dir("aemo", "cache")`
  on first use.
* `\donttest` examples redirect the cache to `tempdir()` via
  `options(aemo.cache_dir = ...)` so no files are written to the
  user's home filespace.
* Data is published by AEMO under its Copyright Permissions
  Notice. The package DESCRIPTION and README both cite this.
* `aemo_bids()` has a hard size guard and refuses spans longer
  than 30 days without `allow_large = TRUE` because
  `BIDPEROFFER_D` monthly archives are 1.5-3 GB zipped.

## Downstream dependencies

None.
