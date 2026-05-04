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
#> Warning: Cache integrity check failed for b2aec91284871c0d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for db5b6b9d469c0eec.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cf18331ac9e83316.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 10e7a8bf983f8e7a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 01e404ee368f3949.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for dc6440f93bd0db25.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b58ffdd7fa90190c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b7a88a2bef031b86.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 530a154e96f563e0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 45c9e0ddb0d9ab0e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for fd4f0969136fdcd0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 62f05652aabc843d.zip; re-downloading.
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
#> # Retrieved: 2026-05-04 19:27 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-05-05 04:30:00     1     NSW1      20260505006            0 57.51000   0
#> 2 2026-05-05 04:35:00     1     NSW1      20260505007            0 57.51000   0
#> 3 2026-05-05 04:40:00     1     NSW1      20260505008            0 57.51000   0
#> 4 2026-05-05 04:45:00     1     NSW1      20260505009            0 57.51000   0
#> 5 2026-05-05 04:50:00     1     NSW1      20260505010            0 57.51000   0
#> 6 2026-05-05 04:55:00     1     NSW1      20260505011            0 64.24231   0
#>        rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1    57.51       0                   0 2026/05/05 04:25:07         0.04
#> 2    57.51       0                   0 2026/05/05 04:30:08         0.04
#> 3    57.51       0                   0 2026/05/05 04:35:01         0.04
#> 4    57.51       0                   0 2026/05/05 04:40:03         0.04
#> 5    57.51       0                   0 2026/05/05 04:45:01         0.04
#> 6 64.24231       0                   0 2026/05/05 04:50:02         0.09
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.04                0          0.03          0.03                 0
#> 2         0.04                0          0.03          0.03                 0
#> 3         0.04                0          0.03          0.03                 0
#> 4         0.04                0          0.03          0.03                 0
#> 5         0.04                0          0.03          0.03                 0
#> 6         0.09                0          0.04          0.04                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        3.47        3.47
#> 2         0.02         0.02                0        3.47        3.47
#> 3         0.02         0.02                0        3.60         3.6
#> 4         0.01         0.01                0        3.58        3.58
#> 5         0.01         0.01                0        3.58        3.58
#> 6         0.02         0.02                0        3.66        3.66
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0         0.01         0.01                0          0.10
#> 2               0         0.01         0.01                0          0.10
#> 3               0         0.01         0.01                0          0.01
#> 4               0         0.01         0.01                0          0.10
#> 5               0         0.01         0.01                0          0.10
#> 6               0         0.01         0.01                0          0.01
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1           0.1                 0         0.01         0.01                0
#> 2           0.1                 0         0.01         0.01                0
#> 3          0.01                 0         0.01         0.01                0
#> 4           0.1                 0         0.01         0.01                0
#> 5           0.1                 0         0.01         0.01                0
#> 6          0.01                 0         0.01         0.01                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1        1.00           1               0         FIRM            57.51000
#> 2        1.51        1.51               0         FIRM            57.51000
#> 3        1.51        1.51               0         FIRM            57.51000
#> 4        1.51        1.51               0         FIRM            57.51000
#> 5        1.00           1               0         FIRM            57.51000
#> 6        1.51        1.51               0         FIRM            64.24231
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.04                 0.03                   0.01
#> 2                0.04                 0.03                   0.02
#> 3                0.04                 0.03                   0.02
#> 4                0.04                 0.03                   0.01
#> 5                0.04                 0.03                   0.01
#> 6                0.09                 0.04                   0.02
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  3.47                0.01                 0.10
#> 2                  3.47                0.01                 0.10
#> 3                  3.60                0.01                 0.01
#> 4                  3.58                0.01                 0.10
#> 5                  3.58                0.01                 0.10
#> 6                  3.66                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                  1.00         0.03         0.03
#> 2                   0.01                  1.51         0.03         0.03
#> 3                   0.01                  1.51         0.04         0.04
#> 4                   0.01                  1.51         0.03         0.03
#> 5                   0.01                  1.00         0.03         0.03
#> 6                   0.01                  1.51         0.04         0.04
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0         0.00            0                0
#> 2                0         0.00            0                0
#> 3                0         0.01         0.01                0
#> 4                0         0.01         0.01                0
#> 5                0         0.01         0.01                0
#> 6                0         0.00            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.03                0.00                  111167.2
#> 2                0.03                0.00                  111147.7
#> 3                0.04                0.01                  111128.2
#> 4                0.03                0.01                  111108.8
#> 5                0.03                0.01                  111089.3
#> 6                0.04                0.00                  111075.6
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                  112.3363                   109.9298
#> 2                  112.3263                   109.9298
#> 3                  112.3263                   109.9298
#> 4                  112.3163                   109.9298
#> 5                  112.3163                   109.9298
#> 6                  112.3563                   109.9398
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                        36.78                    6110.885
#> 2                        36.79                    6109.375
#> 3                        36.80                    6107.995
#> 4                        36.80                    6108.105
#> 5                        36.80                    6106.995
#> 6                        36.81                    6107.275
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  15.98546                   43.96167
#> 2                  15.99546                   44.06167
#> 3                  16.00546                   44.07167
#> 4                  16.01546                   44.17167
#> 5                  16.02546                   44.27167
#> 6                  16.03546                   44.28167
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     21.89203                    3392.595
#> 2                     21.90203                    3392.015
#> 3                     21.91203                    3392.635
#> 4                     21.92203                    3393.235
#> 5                     21.93203                    3393.345
#> 6                     21.94203                    3393.855
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     46.74                      1.67    NOT_OCD    NOT_MII
#> 2                     46.74                      1.67    NOT_OCD    NOT_MII
#> 3                     46.75                      1.68    NOT_OCD    NOT_MII
#> 4                     46.75                      1.69    NOT_OCD    NOT_MII
#> 5                     46.76                      1.70    NOT_OCD    NOT_MII
#> 6                     46.77                      1.70    NOT_OCD    NOT_MII
options(op)
# }
```
