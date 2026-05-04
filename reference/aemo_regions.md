# NEM regions

Returns a static table of the five NEM regions with metadata. The
`market_timezone` column is the AEMO market clock (AEST, UTC+10, no DST,
year-round) that applies to every timestamp in NEMweb files;
`wall_timezone` is the local civil time zone consumers experience
(observes DST in NSW/VIC/TAS/SA).

## Usage

``` r
aemo_regions()
```

## Value

An `aemo_tbl` with columns `region`, `name`, `state`, `wall_timezone`,
`market_timezone`, `commenced`.

## See also

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
aemo_regions()
#> # aemo_tbl: NEM regions
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-04 19:27 UTC 
#> # Rows: 5  Cols: 6
#> 
#>   region            name state       wall_timezone    market_timezone
#> 1   NSW1 New South Wales   NSW    Australia/Sydney Australia/Brisbane
#> 2   QLD1      Queensland   QLD  Australia/Brisbane Australia/Brisbane
#> 3    SA1 South Australia    SA  Australia/Adelaide Australia/Brisbane
#> 4   TAS1        Tasmania   TAS    Australia/Hobart Australia/Brisbane
#> 5   VIC1        Victoria   VIC Australia/Melbourne Australia/Brisbane
#>    commenced
#> 1 1998-12-13
#> 2 1998-12-13
#> 3 1998-12-13
#> 4 2005-05-29
#> 5 1998-12-13
```
