# SPD constraint tables (regions, interconnectors, connection points)

Returns the SPD (Security and Projected Dispatch) constraint coefficient
tables from MMSDM. Where `GENCONDATA` gives the high-level equation
definition, the SPD tables give the per-term *coefficients* used in the
NEMDE dispatch optimisation:

## Usage

``` r
aemo_spd_constraints(
  table = c("region", "interconnector", "connection_point"),
  constraint_id = NULL
)
```

## Source

AEMO NEMweb MMSDM archive, SPDREGIONCONSTRAINT /
SPDINTERCONNECTORCONSTRAINT / SPDCONNECTIONPOINTCONSTRAINT.

## Arguments

- table:

  One of `"region"` (default), `"interconnector"`, or
  `"connection_point"`.

- constraint_id:

  Optional character vector of `GENCONID`/`CONSTRAINTID` values.

## Value

An `aemo_tbl` with columns from the requested SPD table. `GENCONID` and
`FACTOR` (the coefficient) are always present; other columns vary by
table.

## Details

- `"region"`: `SPDREGIONCONSTRAINT` (regional-demand and
  regional-generation terms).

- `"interconnector"`: `SPDINTERCONNECTORCONSTRAINT` (interconnector-flow
  terms).

- `"connection_point"`: `SPDCONNECTIONPOINTCONSTRAINT` (per-DUID
  connection-point terms).

These tables are required for NEM dispatch replication (the `nempy`
Python package, Gorman, Bruce & MacGill 2022, *JOSS* 7(70) 3596,
<doi:10.21105/joss.03596>, uses all three when reproducing NEMDE
solves).

## See also

[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md)
for the equation-level metadata,
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
for the 5-min binding-constraint feed with shadow prices.

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  s <- aemo_spd_constraints(table = "interconnector")
  head(s)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> # aemo_tbl: NEM SPDINTERCONNECTORCONSTRAINT (SPD constraint coefficients)
#> # Source:   https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-09-19 11:09 UTC 
#> # Rows: 6  Cols: 6
#> 
#>   interconnectorid effectivedate versionno            genconid factor
#> 1        VIC1-NSW1    2026-08-01         1 #R036415_001_RAMP_V  0.751
#> 2        VIC1-NSW1    2026-08-01         1 #R036415_001_RAMP_F  0.751
#> 3        N-Q-MNSP1    2026-08-01         1 #R036415_002_RAMP_V -0.168
#> 4        NSW1-QLD1    2026-08-01         1 #R036415_002_RAMP_V -0.173
#> 5        VIC1-NSW1    2026-08-01         1 #R036415_002_RAMP_V  0.714
#> 6        N-Q-MNSP1    2026-08-01         1 #R036415_002_RAMP_F -0.168
#>           lastchanged
#> 1 2026/08/01 19:18:29
#> 2 2026/08/01 19:18:30
#> 3 2026/08/01 19:18:32
#> 4 2026/08/01 19:18:32
#> 5 2026/08/01 19:18:32
#> 6 2026/08/01 19:18:33
options(op)
# }
```
