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

AEMO NEMweb <https://nemweb.com.au>, AEMO Copyright Permissions Notice.

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
#> # Retrieved: 2026-11-01 14:07 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-11-01 23:10:00     1     NSW1      20261101230            0 143.0000   0
#> 2 2026-11-01 23:15:00     1     NSW1      20261101231            0 157.5077   0
#> 3 2026-11-01 23:20:00     1     NSW1      20261101232            0 124.9800   0
#> 4 2026-11-01 23:25:00     1     NSW1      20261101233            0 160.0739   0
#> 5 2026-11-01 23:30:00     1     NSW1      20261101234            0 123.4807   0
#> 6 2026-11-01 23:35:00     1     NSW1      20261101235            0 159.2706   0
#>         rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1       143       0                   0 2026/11/01 23:05:03         0.03
#> 2 157.50767       0                   0 2026/11/01 23:10:03         0.02
#> 3    124.98       0                   0 2026/11/01 23:15:04         0.02
#> 4 160.07391       0                   0 2026/11/01 23:20:04         0.02
#> 5 123.48068       0                   0 2026/11/01 23:25:04         0.02
#> 6 159.27058       0                   0 2026/11/01 23:30:04         0.02
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.03                0          0.02          0.02                 0
#> 2         0.02                0          0.02          0.02                 0
#> 3         0.02                0          0.02          0.02                 0
#> 4         0.02                0          0.02          0.02                 0
#> 5         0.02                0          0.02          0.02                 0
#> 6         0.02                0          0.02          0.02                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        3.46        3.46
#> 2         0.01         0.01                0        3.46        3.46
#> 3         0.01         0.01                0        3.46        3.46
#> 4         0.01         0.01                0        2.40         2.4
#> 5         0.01         0.01                0        0.70         0.7
#> 6         0.01         0.01                0        3.90         3.9
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
#> 1     2.00000           2               0         FIRM            143.0000
#> 2     2.00000           2               0         FIRM            157.5077
#> 3     0.90451     0.90451               0         FIRM            124.9800
#> 4     2.50000         2.5               0         FIRM            160.0739
#> 5     1.00000           1               0         FIRM            123.4807
#> 6     0.37000        0.37               0         FIRM            159.2706
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.03                 0.02                   0.01
#> 2                0.02                 0.02                   0.01
#> 3                0.02                 0.02                   0.01
#> 4                0.02                 0.02                   0.01
#> 5                0.02                 0.02                   0.01
#> 6                0.02                 0.02                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  3.46                0.01                 0.01
#> 2                  3.46                0.01                 0.01
#> 3                  3.46                0.01                 0.01
#> 4                  2.40                0.01                 0.01
#> 5                  0.70                0.01                 0.01
#> 6                  3.90                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01               2.00000         0.01         0.01
#> 2                   0.01               2.00000         0.02         0.02
#> 3                   0.01               0.90451         0.01         0.01
#> 4                   0.01               2.50000         0.01         0.01
#> 5                   0.01               1.00000         0.01         0.01
#> 6                   0.01               0.37000         0.02         0.02
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.01                   0                  184199.4
#> 2                0.02                   0                  184257.4
#> 3                0.01                   0                  184281.0
#> 4                0.01                   0                  184341.5
#> 5                0.01                   0                  184367.3
#> 6                0.02                   0                  184428.6
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                     54.89                      47.15
#> 2                     54.83                      47.15
#> 3                     54.82                      47.15
#> 4                     54.82                      47.15
#> 5                     54.82                      47.16
#> 6                     54.82                      47.17
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                     18.60588                    5608.518
#> 2                     18.60588                    5609.578
#> 3                     18.60588                    5609.588
#> 4                     18.60588                    5611.888
#> 5                     18.60588                    5610.588
#> 6                     18.60588                    5613.138
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                     37.67                   92.84737
#> 2                     37.67                   92.84737
#> 3                     37.67                   92.82737
#> 4                     37.67                   92.82737
#> 5                     37.67                   92.82737
#> 6                     37.67                   92.82737
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                      67.8177                    2471.180
#> 2                      67.8177                    2472.180
#> 3                      67.8177                    2472.085
#> 4                      67.8177                    2473.585
#> 5                      67.8177                    2473.585
#> 6                      67.8177                    2472.925
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     26.40                      1.94    NOT_OCD    NOT_MII
#> 2                     26.39                      1.94    NOT_OCD    NOT_MII
#> 3                     26.38                      1.94    NOT_OCD    NOT_MII
#> 4                     26.37                      1.94    NOT_OCD    NOT_MII
#> 5                     26.36                      1.94    NOT_OCD    NOT_MII
#> 6                     26.36                      1.94    NOT_OCD    NOT_MII
options(op)
# }
```
