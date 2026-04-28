# NEM interconnector flows

Returns MW flows, losses, and limits for one or more NEM interconnectors
from `DISPATCHINTERCONNECTORRES`.

## Usage

``` r
aemo_interconnector(flow = NULL, start, end, intervention = FALSE)
```

## Arguments

- flow:

  Optional character vector of interconnector IDs.

- start, end:

  Window.

- intervention:

  Logical. Default `FALSE`.

## Value

An `aemo_tbl`.

## Details

AEMO's `METEREDMWFLOW` is positive when power flows from `REGIONFROM` to
`REGIONTO`. For per-interconnector direction conventions see
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md).

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
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
  i <- aemo_interconnector(flow = "V-SA",
                            start = now - 3600, end = now)
  head(i)
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
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-28 19:14 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-04-29 04:15:00     1             V-SA      20260429003            0
#> 2 2026-04-29 04:20:00     1             V-SA      20260429004            0
#> 3 2026-04-29 04:25:00     1             V-SA      20260429005            0
#> 4 2026-04-29 04:30:00     1             V-SA      20260429006            0
#> 5 2026-04-29 04:35:00     1             V-SA      20260429007            0
#> 6 2026-04-29 04:40:00     1             V-SA      20260429008            0
#>   meteredmwflow   mwflow mwlosses marginalvalue violationdegree
#> 1      524.1057 529.6757 31.80423             0               0
#> 2      524.8424 529.8833 31.75752             0               0
#> 3      519.8271 521.6871 30.47856             0               0
#> 4      514.0249 498.1119 27.30595             0               0
#> 5      500.4409 493.0000 26.80082             0               0
#> 6      491.3794 471.2698 24.25030             0               0
#>           lastchanged exportlimit importlimit marginalloss exportgenconid
#> 1 2026/04/29 04:10:02   559.47562   -57.77416      1.13653    VS_600_TEST
#> 2 2026/04/29 04:15:03   556.16796   -91.34287      1.13638    VS_600_TEST
#> 3 2026/04/29 04:20:04   553.57192   -32.68956      1.13087    VS_600_TEST
#> 4 2026/04/29 04:25:03    556.2508   -37.96588      1.12536    VS_600_TEST
#> 5 2026/04/29 04:30:04   551.81594   -33.59928      1.12562    VS_600_TEST
#> 6 2026/04/29 04:35:04   559.62476   -39.67068      1.11595    VS_600_TEST
#>   importgenconid fcasexportlimit fcasimportlimit local_price_adjustment_export
#> 1    I_6F_SN_150            1050           -1050                             0
#> 2    I_6F_SN_150            1050           -1050                             0
#> 3    I_6F_SN_150            1050           -1050                             0
#> 4    I_6F_SN_150            1050           -1050                             0
#> 5    I_6F_SN_150            1050           -1050                             0
#> 6    I_6F_SN_150            1050           -1050                             0
#>   locally_constrained_export local_price_adjustment_import
#> 1                          0                             0
#> 2                          0                             0
#> 3                          0                             0
#> 4                          0                             0
#> 5                          0                             0
#> 6                          0                             0
#>   locally_constrained_import
#> 1                          0
#> 2                          0
#> 3                          0
#> 4                          0
#> 5                          0
#> 6                          0
options(op)
# }
```
