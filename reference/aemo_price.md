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
#> # Retrieved: 2026-11-20 08:44 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-11-20 17:45:00     1     NSW1      20261120165            0 117.8800   0
#> 2 2026-11-20 17:50:00     1     NSW1      20261120166            0 117.8800   0
#> 3 2026-11-20 17:55:00     1     NSW1      20261120167            0 118.5000   0
#> 4 2026-11-20 18:00:00     1     NSW1      20261120168            0 122.5773   0
#> 5 2026-11-20 18:05:00     1     NSW1      20261120169            0 117.8800   0
#> 6 2026-11-20 18:10:00     1     NSW1      20261120170            0 123.6198   0
#>         rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1    117.88       0                   0 2026/11/20 17:40:03         0.02
#> 2    117.88       0                   0 2026/11/20 17:45:03         0.02
#> 3     118.5       0                   0 2026/11/20 17:50:03         0.02
#> 4 122.57727       0                   0 2026/11/20 17:55:03         0.02
#> 5    117.88       0                   0 2026/11/20 18:00:04         0.02
#> 6 123.61976       0                   0 2026/11/20 18:05:04         0.02
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.02                0          0.02          0.02                 0
#> 2         0.02                0          0.01          0.01                 0
#> 3         0.02                0          0.01          0.01                 0
#> 4         0.02                0          0.02          0.02                 0
#> 5         0.02                0          0.01          0.01                 0
#> 6         0.02                0          0.01          0.01                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        0.01        0.01
#> 2         0.01         0.01                0        2.00           2
#> 3         0.01         0.01                0        0.01        0.01
#> 4         0.01         0.01                0        2.00           2
#> 5         0.01         0.01                0        1.00           1
#> 6         0.01         0.01                0        0.01        0.01
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
#> 1        1.00           1               0         FIRM            117.8800
#> 2        1.00           1               0         FIRM            117.8800
#> 3        1.03        1.03               0         FIRM            118.5000
#> 4        0.37        0.37               0         FIRM            122.5773
#> 5        2.00           2               0         FIRM            117.8800
#> 6        1.03        1.03               0         FIRM            123.6198
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.02                 0.02                   0.01
#> 2                0.02                 0.01                   0.01
#> 3                0.02                 0.01                   0.01
#> 4                0.02                 0.02                   0.01
#> 5                0.02                 0.01                   0.01
#> 6                0.02                 0.01                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  0.01                0.01                 0.01
#> 2                  2.00                0.01                 0.01
#> 3                  0.01                0.01                 0.01
#> 4                  2.00                0.01                 0.01
#> 5                  1.00                0.01                 0.01
#> 6                  0.01                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                  1.00         0.01         0.01
#> 2                   0.01                  1.00         0.01         0.01
#> 3                   0.01                  1.03         0.01         0.01
#> 4                   0.01                  0.37         0.01         0.01
#> 5                   0.01                  2.00         0.01         0.01
#> 6                   0.01                  1.03         0.01         0.01
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.01                   0                  256609.3
#> 2                0.01                   0                  256546.8
#> 3                0.01                   0                  256501.5
#> 4                0.01                   0                  256439.2
#> 5                0.01                   0                  256371.3
#> 6                0.01                   0                  256329.0
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                     78.61                      66.35
#> 2                     78.59                      66.33
#> 3                     78.57                      66.31
#> 4                     78.56                      66.31
#> 5                     78.55                      66.30
#> 6                     78.53                      66.28
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                         29.7                    8056.858
#> 2                         29.7                    8051.058
#> 3                         29.7                    8046.088
#> 4                         29.7                    8045.688
#> 5                         29.7                    8046.678
#> 6                         29.7                    8045.698
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  19.70987                      52.07
#> 2                  19.70987                      52.07
#> 3                  19.70987                      52.07
#> 4                  19.70987                      52.07
#> 5                  19.70987                      52.07
#> 6                  19.70987                      52.07
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                        27.27                    2903.284
#> 2                        27.27                    2902.104
#> 3                        27.27                    2900.954
#> 4                        27.27                    2899.144
#> 5                        27.27                    2897.154
#> 6                        27.27                    2894.194
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     54.07                      1.68    NOT_OCD    NOT_MII
#> 2                     54.07                      1.68    NOT_OCD    NOT_MII
#> 3                     54.07                      1.68    NOT_OCD    NOT_MII
#> 4                     54.07                      1.68    NOT_OCD    NOT_MII
#> 5                     54.07                      1.68    NOT_OCD    NOT_MII
#> 6                     54.07                      1.68    NOT_OCD    NOT_MII
options(op)
# }
```
