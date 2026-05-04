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
#> Warning: Cache integrity check failed for eaa634678b4a2bca.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cd4602a6994b6b4c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b2aec91284871c0d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for db5b6b9d469c0eec.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cf18331ac9e83316.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 10e7a8bf983f8e7a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 01e404ee368f3949.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for dc6440f93bd0db25.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b58ffdd7fa90190c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b7a88a2bef031b86.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 530a154e96f563e0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 45c9e0ddb0d9ab0e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for fd4f0969136fdcd0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 62f05652aabc843d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO interconnector flows
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-04 19:19 UTC 
#> # Rows: 6  Cols: 22
#> 
#>        settlementdate runno interconnectorid dispatchinterval intervention
#> 1 2026-05-05 04:20:00     1             V-SA      20260505004            0
#> 2 2026-05-05 04:25:00     1             V-SA      20260505005            0
#> 3 2026-05-05 04:30:00     1             V-SA      20260505006            0
#> 4 2026-05-05 04:35:00     1             V-SA      20260505007            0
#> 5 2026-05-05 04:40:00     1             V-SA      20260505008            0
#> 6 2026-05-05 04:45:00     1             V-SA      20260505009            0
#>   meteredmwflow  mwflow mwlosses marginalvalue violationdegree
#> 1      473.2812 487.832 27.30710             0               0
#> 2      500.0781 487.832 26.95402             0               0
#> 3      468.8203 487.832 26.40942             0               0
#> 4      501.1914 487.832 26.03340             0               0
#> 5      510.1211 487.832 26.24481             0               0
#> 6      484.4453 487.832 26.65684             0               0
#>           lastchanged exportlimit importlimit marginalloss exportgenconid
#> 1 2026/05/05 04:15:07     487.832     -441.08      1.12311  V_S_NIL_ROCOF
#> 2 2026/05/05 04:20:10     487.832  -447.33881      1.12235  V_S_NIL_ROCOF
#> 3 2026/05/05 04:25:07     487.832  -450.57106      1.12119  V_S_NIL_ROCOF
#> 4 2026/05/05 04:30:08     487.832  -440.09276      1.12038  V_S_NIL_ROCOF
#> 5 2026/05/05 04:35:01     487.832    -424.762      1.12083  V_S_NIL_ROCOF
#> 6 2026/05/05 04:40:03     487.832  -417.63927      1.12172  V_S_NIL_ROCOF
#>     importgenconid fcasexportlimit fcasimportlimit
#> 1 S_V_HEYWOOD_OFGS            1050           -1050
#> 2 S_V_HEYWOOD_OFGS            1050           -1050
#> 3 S_V_HEYWOOD_OFGS            1050           -1050
#> 4 S_V_HEYWOOD_OFGS            1050           -1050
#> 5 S_V_HEYWOOD_OFGS            1050           -1050
#> 6 S_V_HEYWOOD_OFGS            1050           -1050
#>   local_price_adjustment_export locally_constrained_export
#> 1                        -47.42                          1
#> 2                         -48.9                          1
#> 3                        -48.92                          1
#> 4                        -44.93                          1
#> 5                        -48.98                          1
#> 6                        -24.41                          1
#>   local_price_adjustment_import locally_constrained_import
#> 1                             0                          0
#> 2                             0                          0
#> 3                             0                          0
#> 4                             0                          0
#> 5                             0                          0
#> 6                             0                          0
options(op)
# }
```
