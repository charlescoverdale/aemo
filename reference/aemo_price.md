# Wholesale electricity prices

Returns 5-minute dispatch prices or 30-minute trading prices for a NEM
region over a specified window. Filters intervention runs by default so
the returned prices are the market clearing prices used in settlement.

## Usage

``` r
aemo_price(
  region,
  start,
  end,
  interval = c("5min", "30min"),
  market = c("energy", "fcas"),
  intervention = FALSE
)
```

## Source

AEMO NEMweb
<https://www.aemo.com.au/energy-systems/electricity/national-electricity-market-nem/data-nem/market-data-nemweb>,
AEMO Copyright Permissions Notice.

## Arguments

- region:

  One of `"NSW1"`, `"QLD1"`, `"SA1"`, `"TAS1"`, `"VIC1"`. Accepts a
  vector.

- start, end:

  Start and end times (inclusive). Character (parsed as AEST) or
  `POSIXct`.

- interval:

  One of `"5min"` (default) or `"30min"`.

- market:

  One of `"energy"` (default, returns RRP) or `"fcas"` (returns the FCAS
  service RRPs).

- intervention:

  Logical. `FALSE` (default) returns only the market pricing run; `TRUE`
  returns both market and physical runs, with the `intervention` column
  preserved.

## Value

An `aemo_tbl`. Key columns include `settlementdate` (POSIXct AEST),
`regionid`, `rrp` (AUD/MWh, energy) or the FCAS service RRPs (AUD/MW),
and `intervention`.

## Details

**Timestamps** are AEST (UTC+10, no daylight savings) to match AEMO's
market clock. See the package-level documentation for the period-ending
timestamp convention (a row stamped 00:05 is the 5-minute period ending
at 00:05).

**Intervention.** `DISPATCHPRICE` contains both market pricing runs
(`INTERVENTION = 0`) and physical / intervention runs
(`INTERVENTION = 1`). The default filters to market runs. Pass
`intervention = TRUE` to get both.

**30-minute settlement and the 5MS transition.** Before 1 October 2021
the NEM settled on 30-minute trading prices from `TRADINGPRICE`
(TRADINGIS). On 1 October 2021 five-minute settlement (5MS) commenced
and settlement moved to native 5-minute prices. When
`interval = "30min"`:

- For the pre-5MS period (`start < 2021-10-01`): prices are read from
  TRADINGIS (`TRADINGPRICE`).

- For the post-5MS period: prices are derived by taking the arithmetic
  mean of the six 5-minute dispatch prices within each 30-minute trading
  interval, consistent with how AEMO calculates the `TRADINGPRICE`
  column in TradingIS post-5MS.

**Data availability.** NEMweb holds the 5-minute dispatch files in its
Current directory for only about two days, and daily (dispatch) or
weekly (trading) rollups in its Archive for about 13 months. Each day of
a query is read from an Archive rollup when one exists and from Current
files otherwise. For queries older than the Archive window, use
[`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md)
with an MMSDM URL directly.

## See also

Other price:
[`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  p <- aemo_price("NSW1", now - 3600, now)
  head(p)
})
#> # aemo_tbl: AEMO 5min energy price NSW1
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-19 08:29 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-11-19 17:30:00     1     NSW1      20261119162            0 174.4669   0
#> 2 2026-11-19 17:35:00     1     NSW1      20261119163            0 180.0100   0
#> 3 2026-11-19 17:40:00     1     NSW1      20261119164            0 175.5095   0
#> 4 2026-11-19 17:45:00     1     NSW1      20261119165            0 230.0000   0
#> 5 2026-11-19 17:50:00     1     NSW1      20261119166            0 178.6659   0
#> 6 2026-11-19 17:55:00     1     NSW1      20261119167            0 210.0000   0
#>         rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1 174.46691       0                   0 2026/11/19 17:25:03         0.02
#> 2    180.01       0                   0 2026/11/19 17:30:03         0.03
#> 3  175.5095       0                   0 2026/11/19 17:35:04         0.03
#> 4       230       0                   0 2026/11/19 17:40:04         0.02
#> 5 178.66591       0                   0 2026/11/19 17:45:05         0.04
#> 6       210       0                   0 2026/11/19 17:50:04         0.04
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.02                0          0.02          0.02                 0
#> 2         0.03                0          0.02          0.02                 0
#> 3         0.03                0          0.02          0.02                 0
#> 4         0.02                0          0.02          0.02                 0
#> 5         0.04                0          0.03          0.03                 0
#> 6         0.04                0          0.03          0.03                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        1.00           1
#> 2         0.01         0.01                0        2.00           2
#> 3         0.01         0.01                0        0.10         0.1
#> 4         0.01         0.01                0        3.89        3.89
#> 5         0.01         0.01                0        3.89        3.89
#> 6         0.01         0.01                0        0.10         0.1
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0         0.01         0.01                0          0.01
#> 2               0         0.01         0.01                0          0.01
#> 3               0         0.01         0.01                0          0.01
#> 4               0         0.01         0.01                0          0.01
#> 5               0         0.01         0.01                0          0.01
#> 6               0         0.01         0.01                0          0.01
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1          0.01                 0         0.01         0.01                0
#> 2          0.01                 0         0.01         0.01                0
#> 3          0.01                 0         0.01         0.01                0
#> 4          0.01                 0         0.01         0.01                0
#> 5          0.01                 0         0.01         0.01                0
#> 6          0.01                 0         0.01         0.01                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1        1.00           1               0         FIRM            174.4669
#> 2        2.18        2.18               0         FIRM            180.0100
#> 3        1.00           1               0         FIRM            175.5095
#> 4        2.18        2.18               0         FIRM            230.0000
#> 5        2.00           2               0         FIRM            178.6659
#> 6        4.00           4               0         FIRM            210.0000
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.02                 0.02                   0.01
#> 2                0.03                 0.02                   0.01
#> 3                0.03                 0.02                   0.01
#> 4                0.02                 0.02                   0.01
#> 5                0.04                 0.03                   0.01
#> 6                0.04                 0.03                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  1.00                0.01                 0.01
#> 2                  2.00                0.01                 0.01
#> 3                  0.10                0.01                 0.01
#> 4                  3.89                0.01                 0.01
#> 5                  3.89                0.01                 0.01
#> 6                  0.10                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                  1.00         0.01         0.01
#> 2                   0.01                  2.18         0.01         0.01
#> 3                   0.01                  1.00         0.01         0.01
#> 4                   0.01                  2.18         0.01         0.01
#> 5                   0.01                  2.00         0.02         0.02
#> 6                   0.01                  4.00         0.02         0.02
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.01                   0                  262493.7
#> 2                0.01                   0                  262528.6
#> 3                0.01                   0                  262558.0
#> 4                0.01                   0                  262616.4
#> 5                0.02                   0                  262620.2
#> 6                0.02                   0                  262656.3
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                     83.26                      70.85
#> 2                     83.25                      70.85
#> 3                     83.26                      70.85
#> 4                     83.24                      70.85
#> 5                     83.24                      70.86
#> 6                     83.24                      70.87
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                        30.52                    8519.578
#> 2                        30.52                    8513.578
#> 3                        30.52                    8508.698
#> 4                        30.52                    8502.708
#> 5                        30.52                    8498.598
#> 6                        30.52                    8488.818
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  19.25987                       52.6
#> 2                  19.25987                       52.6
#> 3                  19.25987                       52.6
#> 4                  19.25987                       52.6
#> 5                  19.25987                       52.6
#> 6                  19.25987                       52.6
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                        26.97                    3035.304
#> 2                        26.97                    3033.494
#> 3                        26.97                    3030.504
#> 4                        26.97                    3030.684
#> 5                        26.97                    3031.654
#> 6                        26.97                    3034.624
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     54.15                      1.59    NOT_OCD    NOT_MII
#> 2                     54.14                      1.59    NOT_OCD    NOT_MII
#> 3                     54.14                      1.59    NOT_OCD    NOT_MII
#> 4                     54.13                      1.59    NOT_OCD    NOT_MII
#> 5                     54.13                      1.59    NOT_OCD    NOT_MII
#> 6                     54.14                      1.59    NOT_OCD    NOT_MII
options(op)
# }
```
