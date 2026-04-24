# Marginal Loss Factors (MLF) by DUID and financial year

Returns the Marginal Loss Factor applicable to each DUID for the
requested financial year(s). MLFs measure the incremental network loss
at a connection point relative to the Regional Reference Node (RRN); a
DUID with MLF = 0.97 receives 97% of the regional RRP per MWh generated.

## Usage

``` r
aemo_mlf(year = NULL, duid = NULL)
```

## Source

AEMO MMSDM archive, TRANSMISSIONLOSSFACTOR table. AEMO Copyright
Permissions Notice.

## Arguments

- year:

  Financial year(s) as `"YYYY-YY"` strings (e.g. `"2024-25"`). `NULL`
  returns all available years. Multiple years accepted.

- duid:

  Optional character vector of DUIDs to filter on. `NULL` returns all
  DUIDs. See
  [`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)
  for the full DUID registry.

## Value

An `aemo_tbl` with columns `financial_year`, `duid`,
`connectionpointid`, `regionid`, `mlf`. From a live MMSDM download
additional columns (`participantid`, `lastchanged`) may also be present.

## Details

MLFs are published annually by AEMO under NER 3.6.2 and are used in
settlement calculations and in PPA revenue reconstruction. The function
first attempts to download the `TRANSMISSIONLOSSFACTOR` table from the
most recent MMSDM monthly archive; if that fails it returns a bundled
static table covering FY 2020-21 to FY 2025-26 for ~20 well-known DUIDs.

## See also

[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)
for the DUID registry,
[`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md)
for regional RRPs.

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  mlf <- aemo_mlf(year = "2024-25")
  head(mlf)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> Error in aemo_mlf(year = "2024-25") : 
#>   Could not retrieve TRANSMISSIONLOSSFACTOR from MMSDM.
#> ℹ MLFs are published annually by AEMO under NER 3.6.2. For historical analysis,
#>   download the determination PDF directly from aemo.com.au, or retry when the
#>   MMSDM archive is reachable.
#> ℹ No fallback is provided: unsourced MLF values would be a correctness trap in
#>   settlement and PPA workflows.
options(op)
# }
```
