# NEM market participants and their registered DUIDs

Returns a mapping of NEM market participants (companies) to their
registered Dispatchable Unit Identifiers (DUIDs), joined from the MMSDM
`PARTICIPANT` and `DUDETAILSUMMARY` tables. Use this for corporate
ownership analysis: rolling up generator output or bids from DUID-level
data to the company level.

## Usage

``` r
aemo_participants()
```

## Source

AEMO NEMweb MMSDM archive, PARTICIPANT and DUDETAILSUMMARY tables. AEMO
Copyright Permissions Notice.

## Value

An `aemo_tbl` with columns `participantid`, `participantclassid` (e.g.
`GENERATOR`, `LOAD`, `TRADER`), `name` (company name), `duid`,
`stationid`, `regionid`, `dispatchtype`, `schedule_type`. Rows are one
per participant-DUID combination. If MMSDM is unreachable, returns an
empty table with a warning.

## See also

[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)
for DUID-level registry without participant mapping.

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
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
  pt <- aemo_participants()
  # DUIDs owned by AGL
  pt[grepl("AGL", pt$name, ignore.case = TRUE), ]
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> Warning: Could not reach MMSDM DUDETAILSUMMARY; returning empty participant table.
#> ℹ Check your internet connection.
#> # aemo_tbl: NEM market participants (empty - MMSDM unreachable)
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-31 19:35 UTC 
#> # Rows: 0  Cols: 8
#> 
#> [1] participantid      participantclassid name               duid              
#> [5] stationid          regionid           dispatchtype       schedule_type     
#> <0 rows> (or 0-length row.names)
options(op)
# }
```
