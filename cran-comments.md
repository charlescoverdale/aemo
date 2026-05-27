# CRAN submission comments: aemo 0.4.1

## Reason for this submission

This release fixes the test ERROR shown on the package check page
and reported by the CRAN team on 2026-05-27.

The `aemo_units()` integration test made a live request to the
AEMO MMSDM archive without a `skip_on_cran()` guard. On check
machines where the NEMweb archive was unreachable, the function
aborted (by design, it has no fallback registry), which surfaced
as a test failure. The check passed on the macOS flavours, where
the archive happened to be reachable.

The fix guards the test like every other network-dependent test
in the suite (`skip_on_cran()` plus an offline check) and splits
it into a gated live check and a gated offline-abort check. There
are no user-facing code changes.

## R CMD check results

0 errors | 0 warnings | 0 notes on Mac ARM64, R 4.5.2.

Win-builder / r-hub return one NOTE flagging three terms as
possibly misspelled: "AEMO", "interconnector", "predispatch".
All three are standard domain terms: AEMO is the market operator
acronym, interconnector is the industry term for the transmission
links between NEM regions, and predispatch is the name AEMO uses
for its forward-looking dispatch schedule.

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
