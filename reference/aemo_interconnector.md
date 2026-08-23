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
#> Warning: Cache integrity check failed for 0e2951cf921a0e85.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8fad02e9e2699fb3.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 47f036577fb550b4.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4ad2b1b8db18195b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6bdd24bd99175af0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 00c60f8b0a5bd8bc.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b50cf9bd42706203.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for acf10574eb3eb6e7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7e812257f3b1b363.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8f4aee7951bdaa05.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b75629ed92a8a7d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 622574dedd5c3c53.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 857f4e1cbdbb56f0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-08-23 17:36 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-08-24 02:40:00     1             V-SA      20260823272            0
#> 2 2026-08-24 02:45:00     1             V-SA      20260823273            0
#> 3 2026-08-24 02:50:00     1             V-SA      20260823274            0
#> 4 2026-08-24 02:55:00     1             V-SA      20260823275            0
#> 5 2026-08-24 03:00:00     1             V-SA      20260823276            0
#> 6 2026-08-24 03:05:00     1             V-SA      20260823277            0
#>   meteredmwflow    mwflow mwlosses marginalvalue violationdegree
#> 1      11.19128 -47.47870  0.33797             0               0
#> 2     -70.90674   8.59496 -0.00595             0               0
#> 3     -17.85474  20.77852 -0.01161             0               0
#> 4      48.89758  72.68171  0.52310             0               0
#> 5      76.75732  98.47163  0.97852             0               0
#> 6      78.14478  99.12895  0.97146             0               0
#>           lastchanged exportlimit importlimit marginalloss exportgenconid
#> 1 2026/08/24 02:35:06    -47.4787  -599.27498      0.98877   V::N_SMSY_O1
#> 2 2026/08/24 02:40:06    14.51086  -598.49169      0.99931   V::N_SMSY_O1
#> 3 2026/08/24 02:45:05    20.77851  -568.97633      1.00263   V::N_SMSY_O1
#> 4 2026/08/24 02:50:06    72.68171  -598.75452      1.01644   V::N_SMSY_O1
#> 5 2026/08/24 02:55:06    98.47162  -592.07948      1.02023   V::N_SMSY_O1
#> 6 2026/08/24 03:00:07    99.12895  -370.44408      1.02002   V::N_SMSY_O1
#>    importgenconid fcasexportlimit fcasimportlimit local_price_adjustment_export
#> 1     I_6F_SN_150            1050           -1050                         -6.56
#> 2     I_6F_SN_150            1050           -1050                             0
#> 3     I_6F_SN_150            1050           -1050                         -6.28
#> 4     I_6F_SN_150            1050           -1050                         -8.08
#> 5     I_6F_SN_150            1050           -1050                         -8.23
#> 6 V^^V_NIL_KGTS_2            1050           -1050                        -12.38
#>   locally_constrained_export local_price_adjustment_import
#> 1                          2                             0
#> 2                          0                             0
#> 3                          2                             0
#> 4                          2                             0
#> 5                          2                             0
#> 6                          2                             0
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
