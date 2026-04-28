# Changelog

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
