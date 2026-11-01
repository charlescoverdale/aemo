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

  Financial year(s) as `"YYYY-YY"` strings (e.g. `"2025-26"`). `NULL`
  (the default) returns the current financial year. Multiple years
  accepted; each needs up to 13 small downloads.

- duid:

  Optional character vector of DUIDs to filter on. MMSDM publishes MLFs
  by connection point, so DUIDs are mapped to connection points through
  the unit registry
  ([`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)),
  which adds a `duid` column. `NULL` returns every connection point.

## Value

An `aemo_tbl` with one row per connection point and effective date:
`financial_year`, `connectionpointid`, `regionid`, `mlf`,
`effectivedate`, `versionno`, `secondary_tlf` and `lastchanged`, plus
`duid` when `duid` is given. A factor revised during the year appears
once per effective date.

## Details

MLFs are published annually by AEMO under NER 3.6.2 and are used in
settlement calculations and in PPA revenue reconstruction. Each year's
determination is read from the `TRANSMISSIONLOSSFACTOR` table of the
June MMSDM archive that precedes it, together with the revisions in the
monthly archives after it. There is no bundled fallback: if MMSDM cannot
be reached the function errors rather than return unsourced values.

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
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> # aemo_tbl: NEM Marginal Loss Factors (MLF)
#> # Source:   https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-01 14:07 UTC 
#> # Rows: 6  Cols: 8
#> 
#>      mlf effectivedate versionno connectionpointid regionid         lastchanged
#> 1 1.0000    2025-05-09         1              E003     NSW1 2025/05/12 08:16:21
#> 2 1.0000    2024-09-26         1          NASGRD01     NSW1 2024/09/24 14:28:42
#> 3 1.0002    2024-12-13         1              NCR1     NSW1 2024/12/12 12:23:23
#> 4 0.9167    2025-05-13         1              NCRN     NSW1 2025/05/14 08:05:15
#> 5 0.9167    2025-06-10         1            NCRN1C     NSW1 2025/06/06 16:07:19
#> 6 0.9925    2024-11-13         1              NERB     NSW1 2024/11/12 12:26:17
#>   secondary_tlf financial_year
#> 1          <NA>        2024-25
#> 2          <NA>        2024-25
#> 3          <NA>        2024-25
#> 4          <NA>        2024-25
#> 5          <NA>        2024-25
#> 6          0.99        2024-25
options(op)
# }
```
