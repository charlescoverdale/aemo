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
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 13:45 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-04-24 22:50:00     1             V-SA      20260424226            0
#> 2 2026-04-24 22:55:00     1             V-SA      20260424227            0
#> 3 2026-04-24 23:00:00     1             V-SA      20260424228            0
#> 4 2026-04-24 23:05:00     1             V-SA      20260424229            0
#> 5 2026-04-24 23:10:00     1             V-SA      20260424230            0
#> 6 2026-04-24 23:15:00     1             V-SA      20260424231            0
#>   meteredmwflow    mwflow mwlosses marginalvalue violationdegree
#> 1      10.04102 -23.85761  0.41805             0               0
#> 2      -2.09570 -23.83404  0.38809             0               0
#> 3     -42.22266 -34.50446  0.62767             0               0
#> 4     -28.60547 -13.23999  0.23742             0               0
#> 5     -18.88672 -29.33160  0.62555             0               0
#> 6     -30.32910 -28.97836  0.60823             0               0
#>           lastchanged exportlimit importlimit marginalloss exportgenconid
#> 1 2026/04/24 22:45:04   525.68085   -150.4996      0.97931    V::N_NIL_V2
#> 2 2026/04/24 22:50:04   552.58639  -158.94462      0.98054    V::N_NIL_V2
#> 3 2026/04/24 22:55:04   575.17521  -148.28764      0.97519 V:S_PA_SVC_700
#> 4 2026/04/24 23:00:05   572.17735  -184.15403      0.98213    V::N_NIL_V2
#> 5 2026/04/24 23:05:05   578.49597  -178.14672      0.97614  V_S_NIL_ROCOF
#> 6 2026/04/24 23:10:05   578.49597  -192.29821      0.97644  V_S_NIL_ROCOF
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
