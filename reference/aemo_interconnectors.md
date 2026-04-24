# NEM interconnectors

Returns a static table of the seven NEM interconnectors. The seventh
entry is Project EnergyConnect (PEC), whose Stage 1 was energised on 30
April 2025 with full ~800 MW capability expected mid-2026.

## Usage

``` r
aemo_interconnectors()
```

## Value

An `aemo_tbl` with columns `interconnector_id`, `from_region`,
`to_region`, `name`, `energised`.

## See also

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
aemo_interconnectors()
#> # aemo_tbl: NEM interconnectors
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 14:39 UTC 
#> # Rows: 7  Cols: 5
#> 
#>   interconnector_id from_region to_region                         name
#> 1         NSW1-QLD1        NSW1      QLD1 NSW-QLD Interconnector (QNI)
#> 2         VIC1-NSW1        VIC1      NSW1 VIC-NSW Interconnector (VNI)
#> 3         V-S-MNSP1        VIC1       SA1                   Murraylink
#> 4              V-SA        VIC1       SA1       Heywood Interconnector
#> 5         T-V-MNSP1        TAS1      VIC1                     Basslink
#> 6         N-Q-MNSP1        NSW1      QLD1       Terranora (Directlink)
#> 7             V-S-N        NSW1       SA1  Project EnergyConnect (PEC)
#>    energised
#> 1 2001-02-18
#> 2 1989-01-01
#> 3 2002-10-03
#> 4 1990-11-01
#> 5 2006-04-29
#> 6 2000-12-14
#> 7 2025-04-30
```
