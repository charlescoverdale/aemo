# NEM generators (DUID registry)

Downloads the `DUDETAILSUMMARY` table from the most recent MMSDM monthly
archive and returns one row per registered DUID (Dispatchable Unit
Identifier) with station, region, dispatch type, classification, and
schedule type. Typical output is 500+ DUIDs covering scheduled,
semi-scheduled, and non-scheduled generators, bidirectional storage
(BESS), and loads.

## Usage

``` r
aemo_units(as_of = NULL)
```

## Source

AEMO NEMweb MMSDM archive, DUDETAILSUMMARY table, AEMO Copyright
Permissions Notice.

## Arguments

- as_of:

  Optional `Date` or `POSIXct`. Returns the DUID registry as it was on
  that date. `NULL` (default) returns the current registry.

## Value

An `aemo_tbl` keyed by `duid`. Columns include (from DUDETAILSUMMARY):
`duid`, `stationid`, `regionid`, `dispatchtype` (GENERATOR / LOAD),
`connectionpointid`, `schedule_type` (SCHEDULED / SEMI-SCHEDULED /
NON-SCHEDULED), `start_date`, `end_date`.

## Details

**Effective-date filtering.** `DUDETAILSUMMARY` is effective-dated
(`START_DATE`, `END_DATE` per row with multiple `VERSIONNO` vintages per
DUID over time). The default (`as_of = NULL`) returns rows whose
`[START_DATE, END_DATE]` interval covers the date the MMSDM archive was
published: i.e. the *current* registry. Pass an `as_of` date to get the
registry as it was on that date (essential for historical analysis:
Liddell's four DUIDs were retired in April 2023; pre-2023 queries need
them).

This matches the as-of-join pattern documented in Gorman et al. (2018)
*NEMOSIS* (APSRC) for correct historical joins.

## See also

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  # Current DUID registry
  u <- aemo_units()

  # DUIDs as they were on 1 March 2023 (pre-Liddell retirement)
  u_2023 <- aemo_units(as_of = "2023-03-01")
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
#> Error in aemo_units() : 
#>   Could not retrieve DUDETAILSUMMARY from MMSDM.
#> ℹ Retry when the MMSDM archive is reachable, or use `aemo_nemweb_download()`
#>   with an MMSDM URL directly.
#> ℹ No fallback is provided: a stale or invented DUID registry would silently
#>   mislabel historical analyses.
options(op)
# }
```
