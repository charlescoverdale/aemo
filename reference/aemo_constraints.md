# Binding transmission and system constraints

Returns the `DISPATCHCONSTRAINT` table from NEMweb: one row per binding
(or near-binding) constraint per 5-minute dispatch interval. Each row
records the constraint ID, the left-hand side (LHS) and right-hand side
(RHS) values, the marginal value (shadow price on the constraint in
AUD/MWh), and the violation degree if any.

## Usage

``` r
aemo_constraints(
  start,
  end,
  constraint_id = NULL,
  intervention = FALSE,
  min_marginal_value = 0.01
)
```

## Source

AEMO NEMweb DISPATCHIS_Reports, DISPATCHCONSTRAINT table.

## Arguments

- start, end:

  Window (inclusive), character or POSIXct.

- constraint_id:

  Optional character vector of constraint IDs (e.g. `"N>>N-NIL_1"`,
  `"V::S_NIL_TBSE"`). `NULL` returns all binding constraints in the
  window.

- intervention:

  Logical. Default `FALSE`.

- min_marginal_value:

  Numeric. Only return constraints with marginal value at or above this
  threshold (AUD/MWh). `0` returns every row; the default of `0.01`
  filters out near-zero shadow prices that are typically noise.

## Value

An `aemo_tbl` with columns `settlementdate`, `constraintid`, `rhs`,
`marginalvalue`, `violationdegree`, `lhs`, plus the intervention flag.

## Details

This is the table that answers the question "why was the RRP so high at
17:35?": the sum of marginal values across binding constraints at the
Regional Reference Node equals the regional price component attributable
to network limits.

Constraint equations and RHS terms (`GENCONDATA`, `GENCONSETINVOKE`) are
published through MMSDM on a separate cadence and are not exposed
directly by this function; use
[`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md)
on an MMSDM URL for those.

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
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
  c <- aemo_constraints(start = now - 3600, end = now)
  head(c)
})
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO dispatch constraints (shadow prices)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 13:44 UTC 
#> # Rows: 6  Cols: 13
#> 
#>        settlementdate runno       constraintid dispatchinterval intervention
#> 1 2026-04-24 22:45:00     1  F_I+NIL_APD_TL_L5      20260424225            0
#> 2 2026-04-24 22:45:00     1  F_I+NIL_APD_TL_L6      20260424225            0
#> 3 2026-04-24 22:45:00     1 F_I+NIL_APD_TL_L60      20260424225            0
#> 4 2026-04-24 22:45:00     1      F_I+NIL_MG_R1      20260424225            0
#> 5 2026-04-24 22:45:00     1      F_I+NIL_MG_R6      20260424225            0
#> 6 2026-04-24 22:45:00     1     F_I+NIL_MG_R60      20260424225            0
#>         rhs marginalvalue violationdegree         lastchanged duid
#> 1 518.37191          0.01               0 2026/04/24 22:40:04 <NA>
#> 2 348.21054          0.01               0 2026/04/24 22:40:04 <NA>
#> 3 448.30309          0.01               0 2026/04/24 22:40:04 <NA>
#> 4 351.54329          0.03               0 2026/04/24 22:40:04 <NA>
#> 5 623.78717          0.04               0 2026/04/24 22:40:04 <NA>
#> 6 623.78717          0.03               0 2026/04/24 22:40:04 <NA>
#>   genconid_effectivedate genconid_versionno       lhs
#> 1             2024-07-11                  1 518.37191
#> 2             2024-07-11                  1 348.21053
#> 3             2024-07-11                  1 448.30308
#> 4             2025-02-17                  1 351.54329
#> 5             2022-08-11                  1 623.78717
#> 6             2022-08-11                  1 623.78717
options(op)
# }
```
