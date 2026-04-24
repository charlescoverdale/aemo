# aemo: Australian Energy Market Operator Data

Tidy R access to AEMO's public data: wholesale electricity prices,
demand, dispatch, interconnector flows, rooftop PV, bids, predispatch
and PASA forecasts, FCAS markets, and gas markets across the NEM.

## Main function families

- [`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md),
  [`aemo_demand()`](https://charlescoverdale.github.io/aemo/reference/aemo_demand.md):
  workhorse price and demand.

- [`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
  [`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
  [`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md):
  dispatch and flow.

- [`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
  [`aemo_predispatch()`](https://charlescoverdale.github.io/aemo/reference/aemo_predispatch.md),
  [`aemo_pasa()`](https://charlescoverdale.github.io/aemo/reference/aemo_pasa.md):
  bids and forecasts.

- [`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md),
  [`aemo_gas()`](https://charlescoverdale.github.io/aemo/reference/aemo_gas.md):
  ancillary services and gas.

- [`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md),
  [`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
  [`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md):
  reference data.

- [`aemo_nemweb_ls()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_ls.md),
  [`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md):
  low-level escape hatches for arbitrary NEMweb paths.

- [`aemo_cache_info()`](https://charlescoverdale.github.io/aemo/reference/aemo_cache_info.md),
  [`aemo_clear_cache()`](https://charlescoverdale.github.io/aemo/reference/aemo_clear_cache.md),
  [`aemo_throttle()`](https://charlescoverdale.github.io/aemo/reference/aemo_throttle.md):
  configuration.

## Data source

Data is published by AEMO at <http://nemweb.com.au> under the AEMO
Copyright Permissions Notice
<https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>.

## See also

Useful links:

- <https://github.com/charlescoverdale/aemo>

- Report bugs at <https://github.com/charlescoverdale/aemo/issues>

## Author

**Maintainer**: Charles Coverdale <charlesfcoverdale@gmail.com>
