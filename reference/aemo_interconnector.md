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
#> # Retrieved: 2026-11-19 08:27 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-11-19 17:30:00     1             V-SA      20261119162            0
#> 2 2026-11-19 17:35:00     1             V-SA      20261119163            0
#> 3 2026-11-19 17:40:00     1             V-SA      20261119164            0
#> 4 2026-11-19 17:45:00     1             V-SA      20261119165            0
#> 5 2026-11-19 17:50:00     1             V-SA      20261119166            0
#> 6 2026-11-19 17:55:00     1             V-SA      20261119167            0
#>   meteredmwflow   mwflow mwlosses marginalvalue violationdegree
#> 1      362.7734 359.3118 19.40146             0               0
#> 2      431.9844 381.9844 21.43032             0               0
#> 3      392.9141 362.9141 19.33181             0               0
#> 4      424.1719 394.1719 22.51881             0               0
#> 5      378.4062 378.4062 20.08078             0               0
#> 6      493.3750 463.3750 32.26048             0               0
#>           lastchanged exportlimit importlimit marginalloss   exportgenconid
#> 1 2026/11/19 17:25:03   581.45322        -600      1.10383 V^^S_TBEBUS_SETB
#> 2 2026/11/19 17:30:03   381.98438        -600      1.11153     NRM_VIC1_SA1
#> 3 2026/11/19 17:35:04   362.91406        -600      1.10679     NRM_VIC1_SA1
#> 4 2026/11/19 17:40:04   394.17188        -600      1.11526     NRM_VIC1_SA1
#> 5 2026/11/19 17:45:05   378.40625        -600      1.10865     NRM_VIC1_SA1
#> 6 2026/11/19 17:50:04     463.375  -592.57675      1.13691     NRM_VIC1_SA1
#>       importgenconid fcasexportlimit fcasimportlimit
#> 1    S:V_600_HY_TEST             950            -850
#> 2    S:V_600_HY_TEST             950            -850
#> 3    S:V_600_HY_TEST             950            -850
#> 4    S:V_600_HY_TEST             950            -850
#> 5    S:V_600_HY_TEST             950            -850
#> 6 S>>TBTX4_TUTB_TUTB             950            -850
#>   local_price_adjustment_export locally_constrained_export
#> 1                             0                          0
#> 2                      -8273.11                          1
#> 3                     -26467.46                          1
#> 4                     -26710.38                          1
#> 5                     -26584.51                          1
#> 6                     -26474.13                          1
#>   local_price_adjustment_import locally_constrained_import
#> 1                        175.13                          1
#> 2                        8408.3                          1
#> 3                      26557.07                          1
#> 4                      26716.41                          1
#> 5                      26653.69                          1
#> 6                      26578.96                          1
options(op)
# }
```
