# aemo 0.1.0

Initial CRAN submission. First public release.

The archived `aemo` package (Costigan, 2014-2020, archived
2021-12-29) is superseded by this rewrite. Scope extended from
prices-and-demand to the full NEMweb + MMSDM surface.

## New functions

### Price and demand

* `aemo_price()`: 5-min (DISPATCHPRICE) or 30-min (TRADINGPRICE)
  regional wholesale prices for NEM regions.
* `aemo_demand()`: regional operational, operational-less-SNSG, or
  native demand at 5-min resolution.

### Dispatch and flow

* `aemo_dispatch_units()`: per-DUID generator output at 5-min.
* `aemo_interconnector()`: NEM interconnector flows.
* `aemo_rooftop_pv()`: estimated rooftop PV actual or forecast.
* `aemo_fcas()`: frequency control ancillary services prices
  across 8-10 services.

### Bids and forecasts

* `aemo_bids()`: per-DUID bid stack (with size guards for the
  multi-gigabyte BIDPEROFFER table).
* `aemo_predispatch()`: 5-min-ahead and 40-hour-ahead forecasts.
* `aemo_pasa()`: short-term and medium-term projected assessment
  of system adequacy.

### Gas

* `aemo_gas()`: STTM (Short Term Trading Market) + DWGM
  (Declared Wholesale Gas Market, Victoria).

### Reference

* `aemo_units()`: DUID registry with fuel, capacity, region,
  station, owner.
* `aemo_regions()`: NEM region metadata.
* `aemo_interconnectors()`: interconnector topology.

### Low-level

* `aemo_nemweb_ls()`: list a NEMweb directory.
* `aemo_nemweb_download()`: raw zipped-CSV download.

### Cache and throttling

* `aemo_cache_info()`, `aemo_clear_cache()`.
* `aemo_throttle()`: configure request rate.

## Data source

Data is published by AEMO at <http://nemweb.com.au>. The package
implements AEMO's `C,/I,/D,/F,` row-dispatch CSV format and
respects AEMO's Copyright Permissions Notice
<https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>.
All downloads are cached locally on first use.
