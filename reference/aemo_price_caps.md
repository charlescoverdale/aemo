# NEM market price caps, price floor, and CPT by financial year

Returns a static reference table of the **Market Price Cap (MPC)**,
**Market Price Floor (MPF)**, **Cumulative Price Threshold (CPT)**, and
**Administered Price Cap (APC)** that apply in each NEM financial year
(1 July to 30 June). These are set by the AEMC under NER 3.9.4 and
indexed annually to CPI.

## Usage

``` r
aemo_price_caps()
```

## Value

An `aemo_tbl` with columns `year` (financial year, `"YYYY-YY"`),
`market_price_cap_aud_per_mwh`, `market_price_floor_aud_per_mwh`,
`cumulative_price_threshold_aud`, `administered_price_cap_aud_per_mwh`,
and `source`.

## Details

Use this table to interpret spot-price extremes: any RRP hitting the MPC
(typically AUD 15,000 to 17,500 per MWh depending on year) indicates a
price cap event; when the rolling-seven-day cumulative price in a region
exceeds the CPT (~AUD 1.5 million per MWh-equivalent), AEMO imposes the
APC (AUD 300/MWh) until the CPT falls back below the threshold.

The table covers 2015-16 onwards and is updated on each package release.
For the authoritative current values see
<https://www.aemc.gov.au/regulation/energy-rules/national-electricity-rules>
and the AEMO Reliability Settings publications.

## See also

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_settlement()`](https://charlescoverdale.github.io/aemo/reference/aemo_settlement.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
caps <- aemo_price_caps()
head(caps)
#> # aemo_tbl: NEM market price caps, floor, CPT, and APC
#> # Source:   https://www.aemc.gov.au/regulation/energy-rules/national-electricity-rules
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 14:35 UTC 
#> # Rows: 6  Cols: 6
#> 
#>      year market_price_cap_aud_per_mwh market_price_floor_aud_per_mwh
#> 1 2015-16                        13800                          -1000
#> 2 2016-17                        14000                          -1000
#> 3 2017-18                        14200                          -1000
#> 4 2018-19                        14500                          -1000
#> 5 2019-20                        14700                          -1000
#> 6 2020-21                        15000                          -1000
#>   cumulative_price_threshold_aud administered_price_cap_aud_per_mwh
#> 1                         212800                                300
#> 2                         216500                                300
#> 3                         219700                                300
#> 4                         224300                                300
#> 5                         228700                                300
#> 6                         232900                                300
#>                                                  source_doc
#> 1 AEMC 2014 RSSR final determination (CPI-indexed annually)
#> 2 AEMC 2014 RSSR final determination (CPI-indexed annually)
#> 3 AEMC 2014 RSSR final determination (CPI-indexed annually)
#> 4 AEMC 2018 RSSR final determination (CPI-indexed annually)
#> 5 AEMC 2018 RSSR final determination (CPI-indexed annually)
#> 6 AEMC 2018 RSSR final determination (CPI-indexed annually)
```
