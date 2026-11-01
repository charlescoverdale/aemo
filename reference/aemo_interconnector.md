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
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-01 14:04 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-11-01 23:05:00     1             V-SA      20261101229            0
#> 2 2026-11-01 23:10:00     1             V-SA      20261101230            0
#> 3 2026-11-01 23:15:00     1             V-SA      20261101231            0
#> 4 2026-11-01 23:20:00     1             V-SA      20261101232            0
#> 5 2026-11-01 23:25:00     1             V-SA      20261101233            0
#> 6 2026-11-01 23:30:00     1             V-SA      20261101234            0
#>   meteredmwflow    mwflow mwlosses marginalvalue violationdegree
#> 1     -422.0078 -426.9647 19.09971             0               0
#> 2     -423.1250 -414.0000 18.12975             0               0
#> 3     -426.4688 -454.9851 22.87120             0               0
#> 4     -507.9570 -485.2317 26.86386             0               0
#> 5     -472.2383 -491.5467 27.17404             0               0
#> 6     -522.4688 -505.4983 29.03163             0               0
#>           lastchanged exportlimit importlimit marginalloss  exportgenconid
#> 1 2026/11/01 23:00:03         600  -591.33569      0.90667 V:S_600_HY_TEST
#> 2 2026/11/01 23:05:03         600        -600       0.9095 V:S_600_HY_TEST
#> 3 2026/11/01 23:10:03         600        -600        0.898 V:S_600_HY_TEST
#> 4 2026/11/01 23:15:04   461.01388  -574.76308      0.89006     V::N_NIL_V2
#> 5 2026/11/01 23:20:04         600  -571.86311      0.88743 V:S_600_HY_TEST
#> 6 2026/11/01 23:25:04         600  -578.49401      0.88371 V:S_600_HY_TEST
#>    importgenconid fcasexportlimit fcasimportlimit local_price_adjustment_export
#> 1   S:VN_700_TEST             950            -850                             0
#> 2 S:V_600_HY_TEST             950            -850                             0
#> 3 S:V_600_HY_TEST             950            -850                             0
#> 4   S:VN_700_TEST             950            -850                             0
#> 5   S:VN_700_TEST             950            -850                             0
#> 6   S:VN_700_TEST             950            -850                             0
#>   locally_constrained_export local_price_adjustment_import
#> 1                          0                         -5.72
#> 2                          0                         -5.85
#> 3                          0                         -6.67
#> 4                          0                         -5.82
#> 5                          0                         -6.49
#> 6                          0                         -5.38
#>   locally_constrained_import
#> 1                          1
#> 2                          1
#> 3                          1
#> 4                          1
#> 5                          1
#> 6                          1
options(op)
# }
```
