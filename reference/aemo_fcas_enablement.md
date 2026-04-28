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
#> Warning: Cache integrity check failed for 3d68ee95afa8150e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7e04a6690826e6ac.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cfe993541435e59f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4b5cbf73e6f00631.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 829b75b548ad2f5f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f57d2ebe63c497d8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 987a3c03aabfd59f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9efbd4132ed70868.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7972a9506feaf872.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6573637dad592f8a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0c39ccd2bb4fdc51.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cca2b959d5993570.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f97cba749cf2e79b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4322e37732a56d17.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO FCAS enablement volumes (DISPATCHLOAD)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-28 19:14 UTC 
#> # Rows: 6  Cols: 1
#> 
#>        settlementdate
#> 1 2026-04-29 04:15:00
#> 2 2026-04-29 04:20:00
#> 3 2026-04-29 04:25:00
#> 4 2026-04-29 04:30:00
#> 5 2026-04-29 04:35:00
#> 6 2026-04-29 04:40:00
options(op)
# }
```
