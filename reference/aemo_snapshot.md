# Snapshot provenance for an aemo_tbl

Returns a one-row-per-source provenance record for an `aemo_tbl`,
suitable for inclusion in a paper appendix, a Zenodo deposit, or a
CRAN-style data manifest. The snapshot captures:

## Usage

``` r
aemo_snapshot(x)
```

## Arguments

- x:

  An `aemo_tbl` (or a list of them).

## Value

A data frame with one row per table.

## Details

- `title`: the human-readable title of the table;

- `source`: the NEMweb / MMSDM URL family the table was drawn from;

- `licence`: the AEMO Copyright Permissions Notice (always);

- `retrieved`: the `POSIXct` timestamp at which the table was
  constructed;

- `rows`, `cols`: observed dimensions;

- `sha256`: a SHA-256 digest of the table's printed body, stable across
  R versions and platforms.

The `sha256` column is what makes the snapshot *pinnable*: if the same
query returns a different hash, the underlying data has changed (or the
row-order has, which is also worth knowing). Pair with a git commit of
the analysis script to give a reader a closed reproducibility loop.

## See also

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
x <- structure(
  data.frame(settlementdate = Sys.time(), region = "NSW1", rrp = 80),
  aemo_title = "Demo",
  aemo_source = "http://nemweb.com.au",
  aemo_licence = "AEMO Copyright Permissions Notice",
  aemo_retrieved = Sys.time(),
  class = c("aemo_tbl", "data.frame")
)
aemo_snapshot(x)
#>   title               source                           licence
#> 1  Demo http://nemweb.com.au AEMO Copyright Permissions Notice
#>             retrieved rows cols
#> 1 2026-05-04 19:27:45    1    3
#>                                                             sha256
#> 1 5a9b5545452a36487d6104e95a79122f73f897d28984a713fd4663e583a0b0b4
```
