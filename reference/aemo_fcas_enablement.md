# FCAS enablement volumes by generator unit

Returns the MW enabled for each of the ten Frequency Control Ancillary
Services (FCAS) per DUID per 5-minute dispatch interval from
`DISPATCHLOAD`. This is the quantity side of the FCAS market: how much
each unit was enabled (dispatched) to provide each service, as distinct
from the price returned by
[`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md).

## Usage

``` r
aemo_fcas_enablement(
  duid = NULL,
  start,
  end,
  service = NULL,
  intervention = FALSE
)
```

## Source

AEMO NEMweb DISPATCHIS_Reports, DISPATCHLOAD table.

## Arguments

- duid:

  Optional character vector of DUIDs. `NULL` returns all units. See
  [`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)
  for the full DUID registry.

- start, end:

  Window (inclusive), character or POSIXct.

- service:

  Optional character vector of service names, e.g.
  `c("raise6sec", "lowerreg")`. Case-insensitive. `NULL` returns all ten
  services.

- intervention:

  Logical. Default `FALSE`.

## Value

An `aemo_tbl` with columns `settlementdate`, `duid`, and one column per
FCAS service (`raise1secmw`, `lower1secmw`, `raise6secmw`,
`lower6secmw`, `raise60secmw`, `lower60secmw`, `raise5minmw`,
`lower5minmw`, `raiseregmw`, `lowerregmw`). Values are MW; zero means
the unit was not enabled for that service.

## Details

Ten services are active since 9 October 2023 when Very Fast (`RAISE1SEC`
/ `LOWER1SEC`) commenced. Before that date only eight services are
present; the `raise1secmw` / `lower1secmw` columns will be `NA` for
intervals before that date.

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  e <- aemo_fcas_enablement(start = now - 3600, end = now)
  head(e)
})
#> Warning: Cache integrity check failed for 3bb3714a462ce60e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ea22482a70c0c38b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ca2ede4176c0ab88.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for dd6f61022b493f04.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for bdaa024482966391.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 483f333bf4c3e8f9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 97454525fd1e6df6.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f3003172e9e06b5.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 835a8816869ac35f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ba719dd5c14a0180.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3fad52aee8677171.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f9f86c5ec3bc31d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0cb48725debe07c2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO FCAS enablement volumes (DISPATCHLOAD)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 13:45 UTC 
#> # Rows: 6  Cols: 1
#> 
#>        settlementdate
#> 1 2026-04-24 22:50:00
#> 2 2026-04-24 22:55:00
#> 3 2026-04-24 23:00:00
#> 4 2026-04-24 23:05:00
#> 5 2026-04-24 23:10:00
#> 6 2026-04-24 23:15:00
options(op)
# }
```
