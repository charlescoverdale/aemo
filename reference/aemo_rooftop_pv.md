# Rooftop PV actuals and forecasts

Returns AEMO's region-level estimate of rooftop PV generation, either
actuals or forecasts. Published at 30-minute resolution.

## Usage

``` r
aemo_rooftop_pv(region, start, end, type = c("actual", "forecast"))
```

## Arguments

- region:

  NEM region code.

- start, end:

  Window.

- type:

  One of `"actual"` (default) or `"forecast"`.

## Value

An `aemo_tbl`.

## Details

The "actual" figure is an AEMO estimate derived from the APVI sampling
model and weather data, not metered SCADA output. It is the best
available public measure of aggregate rooftop PV generation but is
subject to revision.

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  r <- aemo_rooftop_pv("NSW1",
                        start = now - 3600, end = now)
  head(r)
})
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_RO…
#> 
#> # aemo_tbl: AEMO rooftop PV actual NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 14:35 UTC 
#> # Rows: 2  Cols: 7
#> 
#>   interval_datetime regionid power  qi        type         lastchanged
#> 1        2026-04-25     NSW1     0   1 MEASUREMENT 2026/04/25 00:19:02
#> 2        2026-04-25     NSW1     0 0.6   SATELLITE 2026/04/25 00:20:19
#>   settlementdate
#> 1     2026-04-25
#> 2     2026-04-25
options(op)
# }
```
