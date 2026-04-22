# aemo

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/aemo)](https://CRAN.R-project.org/package=aemo)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/aemo)](https://cran.r-project.org/package=aemo)
[![R-CMD-check](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Tidy R access to Australian Energy Market Operator data:
wholesale electricity prices, demand, dispatch, interconnector
flows, rooftop PV, bids, predispatch and PASA forecasts, FCAS
markets, and gas markets across the National Electricity Market
('NEM').

Pulls data directly from NEMweb and handles AEMO's `C,/I,/D,/F,`
CSV row-dispatch format.

## Installation

``` r
install.packages("aemo")

# Development:
# install.packages("pak")
pak::pak("charlescoverdale/aemo")
```

## Quick start

``` r
library(aemo)

# Reference data (no network)
aemo_regions()
aemo_interconnectors()

# 5-minute wholesale price for NSW
p <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
head(p)

# Regional demand
d <- aemo_demand("VIC1", "2024-06-01", "2024-06-01 01:00:00")

# Rooftop PV actual generation
r <- aemo_rooftop_pv("NSW1",
                     start = "2024-06-01",
                     end = "2024-06-01 12:00:00")
```

## What's included

| Family | Functions |
|---|---|
| Price + demand | `aemo_price()`, `aemo_demand()` |
| Dispatch + flow | `aemo_dispatch_units()`, `aemo_interconnector()`, `aemo_rooftop_pv()` |
| Bids + forecasts | `aemo_bids()`, `aemo_predispatch()`, `aemo_pasa()` |
| FCAS + gas | `aemo_fcas()`, `aemo_gas()` |
| Reference | `aemo_units()`, `aemo_regions()`, `aemo_interconnectors()` |
| Low-level | `aemo_nemweb_ls()`, `aemo_nemweb_download()` |
| Configuration | `aemo_cache_info()`, `aemo_clear_cache()`, `aemo_throttle()` |

## Size guards

`aemo_bids()` refuses spans longer than 30 days unless you pass
`allow_large = TRUE`: `BIDPEROFFER_D` monthly archives are
1.5-3 GB zipped.

## Data source and licence

Data is published by AEMO at <http://nemweb.com.au> under the
**AEMO Copyright Permissions Notice** (not CC BY 4.0). See
<https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>
for the full terms. This package caches downloads to
`tools::R_user_dir("aemo", "cache")`.

Attribution on derivative work: *"Source: AEMO"*.

## Known quirks

* AEMO flagged a NEMweb base URL migration for 30 April 2026.
  The base URL is configurable via
  `options(aemo.base_url = "...")`.
* `DISPATCHLOAD` schema changed between MMSDM v4.28 and v5.00
  (Oct 2020). The `C,/I,/D,/F,` parser dispatches on the `I` row
  so schema drift is handled per-file.
* AEMO has a known upstream gap in `BIDPEROFFER_D` between
  March 2021 and July 2024. Expect missing observations for
  that span.
* WEMDE (Western Australia post-2023) is not covered in v0.1.0.

## Related packages

* **Python equivalent**: NEMOSIS
  (<https://github.com/UNSW-CEEM/NEMOSIS>), NEMSEER
* [`carbondata`](https://github.com/charlescoverdale/carbondata),
  [`cer`](https://github.com/charlescoverdale/cer): carbon markets
* [`climatekit`](https://github.com/charlescoverdale/climatekit):
  climate indices
* [`readnoaa`](https://github.com/charlescoverdale/readnoaa):
  weather data

## Citation

``` r
citation("aemo")
```

## History

The `aemo` name was previously held by Imanuel Costigan's
package (CRAN 2014-2020, archived 2021-12-29), which implemented
3 functions covering prices and demand. This rewrite covers the
full NEMweb + MMSDM surface and shares only the package name.
