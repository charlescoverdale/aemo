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

AEMO NEMweb <http://nemweb.com.au>, AEMO Copyright Permissions Notice.

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

**Data availability.** NEMweb Current-directory files retain the last
~30 days of 5-minute dispatch files. Historical queries use the Archive
daily-rollup files automatically; for queries older than the Archive
window, use
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
#> Warning: Cache integrity check failed for 21dd0f409f3b043b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ff25b76850c904b8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 58571bf4da845962.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 076374883ffa513e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4be4691aa7671288.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO 5min energy price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-27 21:37 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-04-28 06:40:00     1     NSW1      20260428032            0 102.2966   0
#> 2 2026-04-28 06:45:00     1     NSW1      20260428033            0 109.4100   0
#> 3 2026-04-28 06:50:00     1     NSW1      20260428034            0 124.5383   0
#> 4 2026-04-28 06:55:00     1     NSW1      20260428035            0 105.9714   0
#> 5 2026-04-28 07:00:00     1     NSW1      20260428036            0 103.0180   0
#> 6 2026-04-28 07:05:00     1     NSW1      20260428037            0 106.8327   0
#>         rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1 102.29663       0                   0 2026/04/28 06:35:05         0.10
#> 2    109.41       0                   0 2026/04/28 06:40:05         0.05
#> 3  124.5383       0                   0 2026/04/28 06:45:05         0.39
#> 4 105.97136       0                   0 2026/04/28 06:50:05         0.40
#> 5 103.01802       0                   0 2026/04/28 06:55:06         0.39
#> 6 106.83266       0                   0 2026/04/28 07:00:05         0.37
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1          0.1                0          0.09          0.09                 0
#> 2         0.05                0          0.09          0.09                 0
#> 3         0.39                0          0.17          0.17                 0
#> 4          0.4                0          0.36          0.36                 0
#> 5         0.39                0          0.17          0.17                 0
#> 6         0.37                0          0.15          0.15                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.02         0.02                0        3.47        3.47
#> 2         0.02         0.02                0        3.68        3.68
#> 3         0.03         0.03                0        4.98        4.98
#> 4         0.05         0.05                0        3.47        3.47
#> 5         0.03         0.03                0        3.71        3.71
#> 6         0.03         0.03                0        4.98        4.98
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0            0            0                0             0
#> 2               0            0            0                0             0
#> 3               0            0            0                0             0
#> 4               0            0            0                0             0
#> 5               0            0            0                0             0
#> 6               0            0            0                0             0
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1             0                 0            0            0                0
#> 2             0                 0            0            0                0
#> 3             0                 0            0            0                0
#> 4             0                 0            0            0                0
#> 5             0                 0            0            0                0
#> 6             0                 0            0            0                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1        4.00           4               0         FIRM            102.2966
#> 2        0.88        0.88               0         FIRM            109.4100
#> 3        0.00           0               0         FIRM            124.5383
#> 4        0.88        0.88               0         FIRM            105.9714
#> 5        0.00           0               0         FIRM            103.0180
#> 6        0.00           0               0         FIRM            106.8327
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.10                 0.09                   0.02
#> 2                0.05                 0.09                   0.02
#> 3                0.39                 0.17                   0.03
#> 4                0.40                 0.36                   0.05
#> 5                0.39                 0.17                   0.03
#> 6                0.37                 0.15                   0.03
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  3.47                   0                    0
#> 2                  3.68                   0                    0
#> 3                  4.98                   0                    0
#> 4                  3.47                   0                    0
#> 5                  3.71                   0                    0
#> 6                  4.98                   0                    0
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                      0                  4.00         0.03         0.03
#> 2                      0                  0.88         0.03         0.03
#> 3                      0                  0.00         0.02         0.02
#> 4                      0                  0.88         0.03         0.03
#> 5                      0                  0.00         0.03         0.03
#> 6                      0                  0.00         0.04         0.04
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.03                   0                  108359.4
#> 2                0.03                   0                  108374.4
#> 3                0.02                   0                  108412.8
#> 4                0.03                   0                  108429.9
#> 5                0.03                   0                  108455.9
#> 6                0.04                   0                  108490.7
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                  342.7124                   257.8912
#> 2                  342.7124                   257.8912
#> 3                  343.0524                   258.0212
#> 4                  343.3624                   258.2912
#> 5                  343.7024                   258.3712
#> 6                  344.0224                   258.4312
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                      69.5879                    6807.807
#> 2                      69.5779                    6808.907
#> 3                      69.5879                    6811.307
#> 4                      69.6179                    6812.197
#> 5                      69.6279                    6814.907
#> 6                      69.6379                    6817.307
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  21.38325                   59.06862
#> 2                  21.38325                   59.06862
#> 3                  21.38325                   59.06862
#> 4                  21.38325                   59.06862
#> 5                  21.38325                   59.06862
#> 6                  21.38325                   59.06862
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                        41.57                    4076.222
#> 2                        41.57                    4075.612
#> 3                        41.57                    4074.122
#> 4                        41.57                    4074.282
#> 5                        41.57                    4072.282
#> 6                        41.57                    4070.122
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     52.57                      1.23    NOT_OCD    NOT_MII
#> 2                     52.56                      1.23    NOT_OCD    NOT_MII
#> 3                     52.54                      1.23    NOT_OCD    NOT_MII
#> 4                     52.53                      1.23    NOT_OCD    NOT_MII
#> 5                     52.52                      1.23    NOT_OCD    NOT_MII
#> 6                     52.52                      1.23    NOT_OCD    NOT_MII
options(op)
# }
```
