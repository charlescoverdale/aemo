# Generator bid stack

Returns `BIDDAYOFFER_D` (daily bid summary: 10 price bands, MaxAvail,
fixed load, locked at 12:30 D-1), `BIDPEROFFER_D` (per-interval
availability and rebids), or the two joined on
`(duid, settlementdate, bidtype)`.

## Usage

``` r
aemo_bids(
  duid,
  start,
  end,
  resolution = c("day", "period", "joined"),
  allow_large = FALSE
)
```

## Arguments

- duid:

  Character vector of DUIDs. Required.

- start, end:

  Window.

- resolution:

  One of `"day"` (default, BIDDAYOFFER_D only), `"period"`
  (BIDPEROFFER_D only), or `"joined"` (BIDDAYOFFER_D inner-joined to
  BIDPEROFFER_D on `(duid, settlementdate, bidtype)`).

- allow_large:

  Logical. Default `FALSE`.

## Value

An `aemo_tbl`.

## Details

**Parent / child structure.** `BIDDAYOFFER_D` carries the **price
bands** (`priceband1..priceband10`), which are locked at 12:30 on the
day ahead and cannot be rebid. `BIDPEROFFER_D` carries the
**per-interval availability bands** (`bandavail1..bandavail10`), which
can be rebid intraday. Serious bidding analysis (Goncalves & Menezes
2022 Energy Economics 113 106398; Nelson et al. 2024 AJARE 68(4)) needs
both joined.

**Size warning.** `BIDPEROFFER_D` monthly archives are multi-gigabyte.
By default `aemo_bids()` refuses spans longer than 30 days; pass
`allow_large = TRUE` to override.

**Upstream gap.** AEMO has a documented gap in `BIDPEROFFER_D` between
March 2021 and July 2024. Rows in that range may be missing.

## See also

Other dispatch:
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
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
  # Daily bid summary (price bands)
  b <- aemo_bids(duid = "BW01",
                  start = now - 86400, end = now)

  # Joined: price bands + per-interval volumes
  bj <- aemo_bids(duid = "BW01", start = now - 86400, end = now,
                   resolution = "joined")
})
#> Error in data.frame(name = names_v, modified = NA_character_, size = NA_character_,  : 
#>   arguments imply differing number of rows: 0, 1
options(op)
# }
```
