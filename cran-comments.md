# CRAN submission comments: aemo 0.4.2

## Reason for this submission

This release fixes a network-dependent test that could raise an
intermittent R CMD check ERROR on machines where the NEMweb archive
was unreachable.

`aemo_fcas_enablement()` validated its `service` argument only after
fetching dispatch data, so an unknown service name surfaced the
underlying fetch error rather than the intended "No matching FCAS
service columns" message. On check machines that could not reach
NEMweb this broke the bad-service-name test in `test-dispatch.R`.

The `service` argument is now validated before any network request,
so a bad name fails fast and offline. Behaviour is unchanged for
valid calls.

## R CMD check results

0 errors | 0 warnings | 0 notes on Mac ARM64, R 4.5.2.

The `--as-cran` URL check may flag `www.aemo.com.au` and
`www.aemc.gov.au` as "Forbidden". Both URLs are valid in a browser;
the sites sit behind a WAF that returns 403 to automated clients.
They are the authoritative references for the AEMO copyright notice
and the National Electricity Rules respectively.

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
