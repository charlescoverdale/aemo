# Planned and forced network outages

Returns the `NETWORK_OUTAGEDETAIL` table from MMSDM, which records every
planned and forced outage on NEM transmission and distribution network
elements. Outages are a primary driver of binding constraints and price
spikes: when a line or transformer is out of service the network is more
constrained, reducing the thermal limits that appear as RHS values in
DISPATCHCONSTRAINT.

## Usage

``` r
aemo_outages(start, end, element_id = NULL, outage_type = NULL, region = NULL)
```

## Source

AEMO NEMweb MMSDM archive, NETWORK_OUTAGEDETAIL table. AEMO Copyright
Permissions Notice.

## Arguments

- start, end:

  Outage window (inclusive). Filters on `starttime` and `endtime`: any
  outage active during the window is returned. Character or POSIXct.

- element_id:

  Optional character vector of network element IDs. `NULL` returns all
  elements.

- outage_type:

  Optional character. One of `"PLANNED"`, `"FORCED"`, or `NULL` (both).
  Case-insensitive.

- region:

  Optional NEM region code. Filters on the region column where
  available.

## Value

An `aemo_tbl` with columns from NETWORK_OUTAGEDETAIL including
`outageid`, `starttime`, `endtime`, `substationid`, `equipmenttype`,
`equipmentid`, `outagetype`, `regionid`, and `restarttimeunknown`. Exact
column set depends on the MMSDM version.

## Details

**Use case.** Pair with
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
to explain a price spike: `aemo_outages()` tells you which elements were
off-service at the time;
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
tells you which constraints bound; together they answer "why was SA spot
price AUD 15,000 at 17:35?".

## See also

[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
for the binding constraint shadow prices that these outages drive.

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  # Forced outages during a recent high-price period in SA
  o <- aemo_outages(
    start = "2024-03-01",
    end   = "2024-03-02",
    outage_type = "FORCED"
  )
  head(o)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> Error in aemo_outages(start = "2024-03-01", end = "2024-03-02", outage_type = "FORCED") : 
#>   No outage data found for the requested range.
options(op)
# }
```
