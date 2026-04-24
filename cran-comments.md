# CRAN submission comments: aemo 0.4.0

## Archived-name reclaim

This is a new-maintainership release reclaiming the `aemo`
package name, previously held by Imanuel Costigan's `aemo`
package (v0.1.0 through v0.3.0, on CRAN from June 2014 to
April 2020, archived at the maintainer's request on
2021-12-29).

Version starts at **0.4.0** to sit strictly above Costigan's
last archived version (0.3.0), per CRAN policy on archived-name
reuse.

The earlier package implemented three functions covering
regional prices and demand only. This rewrite is an independent
implementation covering the full NEMweb and MMSDM data surface
(31 exports) and shares only the package name.

Notes on the reclaim:

* The archive is 4+ years old (29 Dec 2021 to Apr 2026).
* The previous maintainer has not been contacted directly. The
  scope of the rewrite is orthogonal to the original (multi-fold
  expansion in functions, data coverage, and tables), the name
  is generic ("aemo" is the market operator itself, not a
  personal brand), and no derivative code has been carried over.
* Happy to contact the previous maintainer and await approval
  if the reviewer prefers.

## R CMD check results

0 errors | 0 warnings | 0 notes on Mac ARM64, R 4.5.2.

## Test suite

Network-dependent tests are wrapped in `skip_on_cran()` and a
custom `skip_if_offline()`. 170+ tests pass offline.

## Notes on data access

* All data sources are public and free. No authentication.
* Downloaded data is cached to `tools::R_user_dir("aemo", "cache")`
  on first use.
* `\donttest` examples redirect the cache to `tempdir()` via
  `options(aemo.cache_dir = ...)` so no files are written to the
  user's home filespace.
* Data is published by AEMO under its Copyright Permissions
  Notice; DESCRIPTION and README both cite the licence terms.
* `aemo_bids()` enforces a 30-day span guard for the
  BIDPEROFFER_D resolutions (`"period"`, `"joined"`) because
  those monthly archives are 1.5 to 3 GB zipped. The `"day"`
  resolution uses the much smaller BIDDAYOFFER_D and is
  unguarded.
* Two options (`aemo.base_url`, `aemo.mmsdm_base`) let users
  point at alternative NEMweb hosts, supporting the
  30 April 2026 AEMO URL migration without a package reinstall.

## Downstream dependencies

None.
