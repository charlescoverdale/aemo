# NEM market notices

Returns the `MARKETNOTICEDATA` feed from MMSDM. Market notices are
AEMO's free-text log of market-relevant events: Lack of Reserve
(LOR1/2/3) declarations, Reliability and Emergency Reserve Trader (RERT)
activations, market suspensions, market directions, unit withdrawals,
system security events, administered price declarations, and operator
advisories.

## Usage

``` r
aemo_market_notices(start, end, notice_type = NULL, region = NULL)
```

## Source

AEMO NEMweb MMSDM archive, MARKETNOTICEDATA table. AEMO Copyright
Permissions Notice.

## Arguments

- start, end:

  Window (inclusive) applied to `EFFECTIVEDATE`.

- notice_type:

  Optional character vector (e.g. `"LOR1"`, `"RERT"`,
  `"PRICES SUBJECT TO REVIEW"`). Case-insensitive substring match.

- region:

  Optional NEM region code.

## Value

An `aemo_tbl` with columns from MARKETNOTICEDATA: `noticeid`,
`effectivedate`, `typeid` (notice category), `originator`, `priority`,
`reason` (the notice text), `externalreference`, and where present
`regionid`.

## Details

Pair with
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
and
[`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md)
to sequence the causal chain of a price event. Rangarajan, Svec, Foley
and Trück (2025, *Energy Economics* 141) use `MARKETNOTICEDATA` to order
the intervention messages that mark entry to and exit from the June 2022
NEM suspension.

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  # LOR declarations during the June 2022 NEM suspension
  n <- aemo_market_notices(
    start = "2022-06-13",
    end   = "2022-06-14",
    notice_type = "LOR"
  )
  head(n)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> Error in aemo_market_notices(start = "2022-06-13", end = "2022-06-14",  : 
#>   Could not retrieve MARKETNOTICEDATA from MMSDM.
#> ℹ Requested months: "2022-06". Check your connection or try
#>   `aemo_nemweb_download()` with an MMSDM URL.
options(op)
# }
```
