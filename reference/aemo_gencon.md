# Generic constraint equations and RHS terms (GENCONDATA)

Downloads the `GENCONDATA` table from the most recent MMSDM monthly
archive. `GENCONDATA` contains the equation definitions for every
generic constraint active in the NEM: the constraint ID, the type
(equality/inequality), a description of what the constraint models
(thermal limit, voltage stability, system strength, etc.), and the
default RHS value.

## Usage

``` r
aemo_gencon(constraint_id = NULL, type = NULL)
```

## Source

AEMO NEMweb MMSDM archive, GENCONDATA table. AEMO Copyright Permissions
Notice.

## Arguments

- constraint_id:

  Optional character vector of constraint IDs to filter on. `NULL`
  returns all equations.

- type:

  Optional constraint type filter (e.g. `"LE"` for `<=`, `"GE"` for
  `>=`, `"EQ"` for `=`). `NULL` returns all types.

## Value

An `aemo_tbl` with columns including `genconid` (constraint ID),
`constrainttype`, `description`, `genericconstraintrhs` (default RHS
value). Additional columns from GENCONDATA (effective dates, generic
constraint equation weights) will be present when available.

## Details

Pair this with
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
to go from a binding dispatch interval to the underlying network
equation. The workflow is:
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
tells you *which* constraint bound and *how hard* (marginalvalue =
shadow price); `aemo_gencon()` tells you *what the constraint is* (which
elements and why the RHS was set at that level).

## See also

[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
for the real-time binding constraint shadow prices.

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
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
  # Find equations for the Heywood interconnector thermal limits
  g <- aemo_gencon(constraint_id = c("V::S_NIL_TBSE", "V::S_NIL_FCSPS"))
  head(g)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> # aemo_tbl: NEM generic constraint equations (GENCONDATA)
#> # Source:   https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 13:45 UTC 
#> # Rows: 0  Cols: 26
#> 
#>  [1] effectivedate           versionno               genconid               
#>  [4] constrainttype          constraintvalue         description            
#>  [7] status                  genericconstraintweight authoriseddate         
#> [10] authorisedby            dynamicrhs              lastchanged            
#> [13] dispatch                predispatch             stpasa                 
#> [16] mtpasa                  additionalnotes         p5min_scope_override   
#> [19] lrc                     lor                     impact                 
#> [22] source                  limittype               reason                 
#> [25] modifications           force_scada            
#> <0 rows> (or 0-length row.names)
options(op)
# }
```
