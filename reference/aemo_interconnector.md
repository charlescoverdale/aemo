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
#> Warning: Cache integrity check failed for d15d470c4a6a9a24.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for a8a882bfffda28c7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 64a5dec40bed14bf.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c2d69e7fd374a18f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 09ceddd4b8e23f70.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6080e733a9d5e2ee.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4519db0ecbcd63ed.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 53aeb92b6406fab8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 521c3ebd63a722f9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b3c0151c599da35.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 55237c7ddeaa8ce7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3567538254aae775.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7ff46adf86691433.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6287474405ad3d0f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-09-19 10:27 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-09-19 19:30:00     1             V-SA      20260919186            0
#> 2 2026-09-19 19:35:00     1             V-SA      20260919187            0
#> 3 2026-09-19 19:40:00     1             V-SA      20260919188            0
#> 4 2026-09-19 19:45:00     1             V-SA      20260919189            0
#> 5 2026-09-19 19:50:00     1             V-SA      20260919190            0
#> 6 2026-09-19 19:55:00     1             V-SA      20260919191            0
#>   meteredmwflow    mwflow mwlosses marginalvalue violationdegree
#> 1     -127.1334 -170.0000  4.82993             0               0
#> 2     -187.3525 -281.8791 11.63138             0               0
#> 3     -240.2246 -294.9662 11.84545             0               0
#> 4     -259.6924 -234.9532  7.57808             0               0
#> 5     -207.1055 -190.6807  4.96446             0               0
#> 6     -149.1758 -272.2268  9.63579             0               0
#>           lastchanged exportlimit importlimit marginalloss  exportgenconid
#> 1 2026/09/19 19:25:02   609.99097  -249.79123      0.95512   V_S_NIL_ROCOF
#> 2 2026/09/19 19:30:03   599.59437  -281.87915      0.92944 V::S_SEVC1_SETB
#> 3 2026/09/19 19:35:03   564.62334  -294.96619      0.92824 V::S_SEVC1_SETB
#> 4 2026/09/19 19:40:03   543.40993  -234.95319      0.94377 V::S_SEVC1_SETB
#> 5 2026/09/19 19:45:03   582.74487  -190.68072      0.95225 V::S_SEVC1_SETB
#> 6 2026/09/19 19:50:04   609.99097  -272.22676      0.93385   V_S_NIL_ROCOF
#>   importgenconid fcasexportlimit fcasimportlimit local_price_adjustment_export
#> 1    I_6F_SN_150            1050           -1050                             0
#> 2    I_6F_SN_150            1050           -1050                             0
#> 3    I_6F_SN_150            1050           -1050                             0
#> 4    I_6F_SN_150            1050           -1050                             0
#> 5    I_6F_SN_150            1050           -1050                             0
#> 6    I_6F_SN_150            1050           -1050                             0
#>   locally_constrained_export local_price_adjustment_import
#> 1                          0                             0
#> 2                          0                          5.08
#> 3                          0                           5.6
#> 4                          0                          17.8
#> 5                          0                         28.42
#> 6                          0                          7.39
#>   locally_constrained_import
#> 1                          0
#> 2                          1
#> 3                          1
#> 4                          1
#> 5                          1
#> 6                          1
options(op)
# }
```
