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
#> # Retrieved: 2026-11-20 08:42 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-11-20 17:45:00     1             V-SA      20261120165            0
#> 2 2026-11-20 17:50:00     1             V-SA      20261120166            0
#> 3 2026-11-20 17:55:00     1             V-SA      20261120167            0
#> 4 2026-11-20 18:00:00     1             V-SA      20261120168            0
#> 5 2026-11-20 18:05:00     1             V-SA      20261120169            0
#> 6 2026-11-20 18:10:00     1             V-SA      20261120170            0
#>   meteredmwflow    mwflow mwlosses marginalvalue violationdegree
#> 1     -407.4961 -394.4004 21.98098             0               0
#> 2     -409.7266 -399.0000 22.59898             0               0
#> 3     -428.7031 -450.3445 27.50726             0               0
#> 4     -449.9141 -421.6340 23.77198             0               0
#> 5     -414.1953 -461.3136 27.90495             0               0
#> 6     -440.9844 -436.5651 24.48183             0               0
#>           lastchanged exportlimit importlimit marginalloss     exportgenconid
#> 1 2026/11/20 17:40:03   544.57644  -570.53708      0.89995 S>>NIL_TBTU_TBMO_1
#> 2 2026/11/20 17:45:03    560.5183  -566.93357      0.89965 S>>NIL_TBTU_TBMO_1
#> 3 2026/11/20 17:50:03   574.21915        -600      0.88786 S>>NIL_TBTU_TBMO_1
#> 4 2026/11/20 17:55:03   587.19256        -600      0.89561   V::S_TBEBUS_SETB
#> 5 2026/11/20 18:00:04   580.74202  -588.37078      0.88621   V::S_TBEBUS_SETB
#> 6 2026/11/20 18:05:04   579.35542  -584.73564      0.89415   V::S_TBEBUS_SETB
#>    importgenconid fcasexportlimit fcasimportlimit local_price_adjustment_export
#> 1   S:VN_900_TEST             950            -850                             0
#> 2   S:VN_900_TEST             950            -850                             0
#> 3 S:V_600_HY_TEST             950            -850                             0
#> 4 S:V_600_HY_TEST             950            -850                             0
#> 5   S:VN_900_TEST             950            -850                             0
#> 6   S:VN_900_TEST             950            -850                             0
#>   locally_constrained_export local_price_adjustment_import
#> 1                          0                         -2.99
#> 2                          0                          -2.1
#> 3                          0                         -4.14
#> 4                          0                         -3.89
#> 5                          0                         -2.75
#> 6                          0                         -2.57
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
