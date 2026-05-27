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
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO dispatch constraints (shadow prices)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-27 07:56 UTC 
#> # Rows: 6  Cols: 13
#> 
#>        settlementdate runno   constraintid dispatchinterval intervention
#> 1 2026-05-27 17:00:00     1  F_I+LREG_0210      20260527156            0
#> 2 2026-05-27 17:00:00     1  F_I+NIL_MG_R1      20260527156            0
#> 3 2026-05-27 17:00:00     1  F_I+NIL_MG_R5      20260527156            0
#> 4 2026-05-27 17:00:00     1  F_I+NIL_MG_R6      20260527156            0
#> 5 2026-05-27 17:00:00     1 F_I+NIL_MG_R60      20260527156            0
#> 6 2026-05-27 17:00:00     1     F_Q++8E_L5      20260527156            0
#>          rhs marginalvalue violationdegree         lastchanged duid
#> 1        210          1.69               0 2026/05/27 16:55:03 <NA>
#> 2  263.73651          0.01               0 2026/05/27 16:55:03 <NA>
#> 3  709.37681          0.02               0 2026/05/27 16:55:03 <NA>
#> 4  621.35649          0.04               0 2026/05/27 16:55:03 <NA>
#> 5  621.35649          0.03               0 2026/05/27 16:55:03 <NA>
#> 6 -148.12297          0.09               0 2026/05/27 16:55:03 <NA>
#>   genconid_effectivedate genconid_versionno        lhs
#> 1             2022-08-11                  1        210
#> 2             2025-02-17                  1  263.73651
#> 3             2022-08-11                  1  709.37681
#> 4             2022-08-11                  1  621.35649
#> 5             2022-08-11                  1  621.35648
#> 6             2023-03-13                  1 -148.12297
options(op)
# }
```
