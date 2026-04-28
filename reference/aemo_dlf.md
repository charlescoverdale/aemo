# Distribution Loss Factors (DLF) by connection point

Returns the Distribution Loss Factor for NEM connection points from the
MMSDM `LOSSFACTORMODEL` table. DLFs measure the average energy loss on
the distribution network between a connection point and the transmission
network boundary; a DLF of 1.02 means the generator must produce 2% more
energy than it delivers to the transmission system.

## Usage

``` r
aemo_dlf(year = NULL, connection_point_id = NULL)
```

## Source

AEMO MMSDM archive, LOSSFACTORMODEL table. AEMO Copyright Permissions
Notice.

## Arguments

- year:

  Financial year(s) as `"YYYY-YY"`. `NULL` returns all available years.

- connection_point_id:

  Optional character vector of connection point IDs.

## Value

An `aemo_tbl` with at minimum `financial_year`, `connectionpointid`, and
`dlf`.

## Details

DLFs are published annually by AEMO (NER 3.6.3) and combined with MLFs
in settlement to give the total loss factor (TLF = MLF x DLF) used in
energy payments.

## See also

Other reference:
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
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
  dlf <- aemo_dlf(year = "2024-25")
  head(dlf)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> # aemo_tbl: NEM Distribution Loss Factors (DLF)
#> # Source:   https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-28 19:13 UTC 
#> # Rows: 6  Cols: 7
#> 
#>     effectivedate versionno interconnectorid regionid demandcoefficient
#> 403    2024-07-01         1             V-SA      SA1        6.2183e-05
#> 404    2024-07-01         1             V-SA     VIC1       -1.6267e-05
#> 405    2024-07-01         1        VIC1-NSW1     NSW1        1.2083e-06
#> 406    2024-07-01         1        VIC1-NSW1      SA1       -6.4190e-05
#> 407    2024-07-01         1        VIC1-NSW1     VIC1        2.1896e-06
#> 408    2024-07-01         1        V-S-MNSP1     VIC1        0.0000e+00
#>             lastchanged financial_year
#> 403 2024/06/24 11:05:26        2024-25
#> 404 2024/06/24 11:05:26        2024-25
#> 405 2024/06/24 11:05:26        2024-25
#> 406 2024/06/24 11:05:26        2024-25
#> 407 2024/06/24 11:05:26        2024-25
#> 408 2024/06/24 11:05:26        2024-25
options(op)
# }
```
