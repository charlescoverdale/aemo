# Changelog

## aemo 0.4.3

Bug-fix release. Most queries for data more than about two days old
failed, the download cache never worked,
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md)
failed for every date and
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md)
outside July. Live tests that would have shown this were being skipped.

### Queries older than two days work again

NEMweb now keeps the five-minute files in its `Current` directory for
only about two days; the package assumed 30. Any
[`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md),
[`aemo_demand()`](https://charlescoverdale.github.io/aemo/reference/aemo_demand.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md)
or other NEMweb query for a day between two and 30 days ago therefore
looked only in `Current`, found nothing, and stopped with “No NEMweb
files matched the requested range”. Older days fell through to the
`Archive`, which failed too (see below). Each day is now read from an
`Archive` rollup when one exists and from `Current` otherwise, whatever
NEMweb’s retention.

- `Archive` rollups are zips of zips (a daily DispatchIS rollup holds
  the day’s 288 five-minute zips). The parser only looked for CSVs at
  the top level, so every `Archive` file was skipped as a failed
  download. Nested zips are now unpacked, and only the inner files
  inside the requested window are parsed: an hour’s query reads a dozen
  files, not 288.
- Weekly `Archive` rollups (TradingIS, used by `interval = "30min"`)
  were matched only to the first day they cover. They now count for all
  seven.
- The interval ending at 00:00 is now read from the previous day’s
  rollup, where NEMweb files it.
- When a range is older than NEMweb holds, the error now gives the
  earliest date available and points to MMSDM.
- When some files in a range fail to download, the result was returned
  with one “Skipping failed download” warning per file, which made an
  incomplete series easy to miss. There is now a single warning saying
  how many files are missing and that the result lacks those intervals
  (class `aemo_partial_download`); if every download fails the error has
  class `aemo_download_error`.

### Bids

- [`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md)
  failed for every date with “arguments imply differing number of rows:
  0, 1”. Its default `resolution = "day"` (and `"joined"`) read
  `Next_Day_Offer_Energy`, which AEMO has emptied in favour of
  `Next_Day_Offer_Energy_SPARSE`, and listing an empty NEMweb folder
  crashed
  [`aemo_nemweb_ls()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_ls.md).
  Day bids are now read from `Bidmove_Complete`, which carries both
  `BIDDAYOFFER_D` and `BIDPEROFFER_D`, and an empty folder lists as an
  empty data frame.

- `resolution = "period"` returned `BIDDAYOFFER_D`, the daily table,
  because it took the first table in each `Bidmove_Complete` file. It
  now names `BIDPEROFFER_D`, and `"day"` names `BIDDAYOFFER_D`.

- Monthly archive rollups named by a single date
  (`PUBLIC_BIDMOVE_COMPLETE_20251002.zip`, which holds 2 October to 1
  November) were treated as covering that one day, so a request for any
  other day in the month missed them. A single-date rollup now runs to
  the next rollup; daily rollups are unaffected.

### Marginal loss factors

[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md)
read the newest monthly MMSDM `TRANSMISSIONLOSSFACTOR` file. Only the
June file holds the full determination for the year ahead; the other
months carry a few revisions, so outside July the function found too few
rows and reported MMSDM as unreachable. Each requested year is now built
from its June file and the revisions after it, keeping the latest
version of each factor. `year = NULL` returns the current financial year
(previously documented as all years).

The `duid` filter did nothing, because MMSDM publishes MLFs by
connection point and the table has no `duid` column. DUIDs are now
mapped to connection points through
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md),
which adds a `duid` column. The help page also described a bundled
fallback table that the function deliberately does not have; it no
longer does.

### HTTPS

NEMweb now redirects `http://` to `https://`; the package requests
`https://nemweb.com.au` directly.

### The cache works

`aemo_sha256_file()` returned openssl’s `"hash"` object rather than a
plain string, so the integrity check against the stored digest always
failed: every cached file was reported as corrupt, deleted and
downloaded again. It now returns a plain string. It also closes the file
connection it opens, and `aemo_parse_csv()` no longer opens a text
connection per CSV line without closing it.

### Tests

The integration tests checked reachability against
`http://nemweb.com.au`, which now redirects to aemo.com.au and returns
403, so they were always skipped; their fixed 2021-2024 dates had also
aged out of NEMweb. They now probe the reports directory and use dates
relative to today.

## aemo 0.4.2

CRAN release: 2026-09-09

Maintenance release fixing a network-dependent test that could fail the
package check whenever the NEMweb archive was unreachable.

[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md)
validated its `service` argument only after fetching dispatch data, so
an unknown service name surfaced the underlying fetch error (for example
“NEMweb returned HTTP 403”) rather than the intended “No matching FCAS
service columns” message. On check machines that could not reach NEMweb
this broke the bad-service-name test in `test-dispatch.R`, producing an
intermittent R CMD check ERROR on the flavours where the archive
happened to be unreachable.

The `service` argument is now validated before any network request, so a
bad name fails fast and offline. No change for valid calls.

## aemo 0.4.1

CRAN release: 2026-05-27

Maintenance release fixing a test-suite issue reported by CRAN on
2026-05-27. The
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)
integration test made a live MMSDM request without a `skip_on_cran()`
guard, so it raised an error on CRAN check machines whenever the NEMweb
archive was unreachable. The test is now guarded like the other
network-dependent tests and split into a gated live check and an
offline-abort check that verifies the no-fallback behaviour. No
user-facing code changes.

## aemo 0.4.0

CRAN release: 2026-04-28

First release under new maintainership. Reclaims the archived `aemo`
package name (Imanuel Costigan, 2014-2020, v0.1.0 to v0.3.0, archived
2021-12-29). The prior package shipped three functions covering regional
prices and demand only; this release is an independent rewrite covering
the full NEMweb and MMSDM data surface and shares only the package name.

Version starts at 0.4.0 to sit strictly above the last archived version
(0.3.0).

### Data functions

#### Price and demand

- [`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md):
  5-min (DISPATCHPRICE) or 30-min (TRADINGPRICE) regional wholesale
  prices. Pre-5MS (before 2021-10-01) reads TRADINGIS; post-5MS 30-min
  prices are derived as the arithmetic mean of six 5-min dispatch prices
  within each trading interval, matching AEMO’s post-5MS TRADINGPRICE
  derivation.
- [`aemo_demand()`](https://charlescoverdale.github.io/aemo/reference/aemo_demand.md):
  regional operational, operational-less-SNSG, or native demand at 5-min
  resolution.
- [`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md):
  static reference table of Market Price Cap, Floor, CPT, and APC by
  financial year. Per-row source citations to the specific AEMC
  determination.

#### Dispatch and flow

- [`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md):
  per-DUID generator output at 5-min. `measure = "scada_mw"` (default)
  returns SCADA actual; `"target_mw"` returns DISPATCHLOAD TOTALCLEARED;
  `"both"` returns INITIALMW + TOTALCLEARED + SCADAVALUE paired,
  enabling ramp-trajectory research.
- [`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md):
  NEM interconnector flows.
- [`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md):
  estimated rooftop PV actual or forecast.
- [`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md),
  [`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md):
  FCAS prices and enablement across the ten services live since 9 Oct
  2023.
- [`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md):
  binding transmission and system constraints with shadow prices.
- [`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md):
  GENCONDATA constraint equations.
- [`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md):
  SPD constraint coefficient tables (SPDREGIONCONSTRAINT,
  SPDINTERCONNECTORCONSTRAINT, SPDCONNECTIONPOINTCONSTRAINT). Required
  for nempy-style dispatch replication (Gorman et al. 2022 JOSS 7(70)
  3596).
- [`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md):
  NETWORK_OUTAGEDETAIL.
- [`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md):
  MARKETNOTICEDATA feed (LOR, RERT, interventions, suspensions). Pairs
  with the above for market- event forensics (Rangarajan et al. 2025,
  Energy Economics 141).

#### Bids and forecasts

- [`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md):
  generator bid stack. `resolution = "day"` (BIDDAYOFFER_D), `"period"`
  (BIDPEROFFER_D), or `"joined"` (the two inner-joined on (duid,
  settlementdate, bidtype) so price bands and volumes are accessible
  together).
- [`aemo_predispatch()`](https://charlescoverdale.github.io/aemo/reference/aemo_predispatch.md):
  P5MIN or PREDISPATCH forecasts. Pass `run_datetime` to pin a specific
  forecast vintage (required for forecast-error research; mirrors
  NEMSEER’s workflow, Prakash 2023 JOSS 8(92) 5883).
- [`aemo_pasa()`](https://charlescoverdale.github.io/aemo/reference/aemo_pasa.md):
  short-term or medium-term projected assessment of system adequacy.
  Default windows are horizon-aware.

#### Gas

- [`aemo_gas()`](https://charlescoverdale.github.io/aemo/reference/aemo_gas.md):
  STTM and DWGM.

#### Reference and settlement

- [`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md):
  DUID registry. `as_of` argument performs an effective-date join on
  DUDETAILSUMMARY so historical queries see the registry as it was at
  any point in time (e.g. Liddell’s DUIDs pre-2023 retirement).
- [`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md):
  PARTICIPANT + DUDETAILSUMMARY.
- [`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
  [`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md):
  static metadata.
- [`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
  [`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md):
  marginal and distribution loss factors from MMSDM.
- [`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md):
  SETCFM (energy cashflow), SETFCASREGIONRECOVERY (FCAS recovery), and
  SETRESIDUECONTRACTPAYMENT (settlement residues) for gentailer
  reconciliation workflows.

#### Reproducibility

- [`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md):
  returns a provenance record (source URL, SHA-256 of the table body,
  row count, retrieved-at timestamp) suitable for Zenodo deposit or
  paper appendix.

#### Low-level access and configuration

- [`aemo_nemweb_ls()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_ls.md),
  [`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md):
  escape hatches for arbitrary NEMweb paths.
- [`aemo_cache_info()`](https://charlescoverdale.github.io/aemo/reference/aemo_cache_info.md),
  [`aemo_clear_cache()`](https://charlescoverdale.github.io/aemo/reference/aemo_clear_cache.md),
  [`aemo_throttle()`](https://charlescoverdale.github.io/aemo/reference/aemo_throttle.md).

### Conventions

- All timestamps are POSIXct in `Australia/Brisbane` (AEST, UTC+10, no
  DST). NER cl. 2.2.6. Using `Australia/Sydney` would silently shift
  every summer interval by one hour.
- Period-ending timestamps throughout.
- `intervention = FALSE` (default) filters DISPATCHPRICE to the market
  pricing run (`INTERVENTION = 0`) used in settlement. Pass
  `intervention = TRUE` for intervention runs (e.g. the June 2022 NEM
  suspension).
- `options("aemo.base_url")` and `options("aemo.mmsdm_base")` override
  the NEMweb host endpoints, supporting the 30 April 2026 NEMweb URL
  migration without a reinstall.

### Data source

Data is published by AEMO at <http://nemweb.com.au> under the AEMO
Copyright Permissions Notice
<https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>.
Downloads are cached to `tools::R_user_dir("aemo", "cache")` on first
use, with SHA-256 content verification on reuse.
