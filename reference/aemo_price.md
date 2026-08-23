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
#> Warning: Cache integrity check failed for 7e812257f3b1b363.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8f4aee7951bdaa05.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b75629ed92a8a7d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 622574dedd5c3c53.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 857f4e1cbdbb56f0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO 5min energy price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-08-23 18:16 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-08-24 03:20:00     1     NSW1      20260823280            0 62.60320   0
#> 2 2026-08-24 03:25:00     1     NSW1      20260823281            0 45.44000   0
#> 3 2026-08-24 03:30:00     1     NSW1      20260823282            0 57.39007   0
#> 4 2026-08-24 03:35:00     1     NSW1      20260823283            0 60.99437   0
#> 5 2026-08-24 03:40:00     1     NSW1      20260823284            0 61.38036   0
#> 6 2026-08-24 03:45:00     1     NSW1      20260823285            0 62.15683   0
#>        rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1  62.6032       0                   0 2026/08/24 03:15:07         0.04
#> 2    45.44       0                   0 2026/08/24 03:20:07         0.04
#> 3 57.39007       0                   0 2026/08/24 03:25:07         0.04
#> 4 60.99437       0                   0 2026/08/24 03:30:08         0.03
#> 5 61.38036       0                   0 2026/08/24 03:35:00         0.04
#> 6 62.15683       0                   0 2026/08/24 03:40:01         0.04
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.04                0          0.04          0.04                 0
#> 2         0.04                0          0.04          0.04                 0
#> 3         0.04                0          0.03          0.03                 0
#> 4         0.03                0          0.03          0.03                 0
#> 5         0.04                0          0.03          0.03                 0
#> 6         0.04                0          0.03          0.03                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0      3.6800        3.68
#> 2         0.01         0.01                0      3.4500        3.45
#> 3         0.01         0.01                0      3.3300        3.33
#> 4         0.01         0.01                0      8.6043      8.6043
#> 5         0.01         0.01                0      3.3800        3.38
#> 6         0.01         0.01                0      1.4700        1.47
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0         0.01         0.01                0          0.01
#> 2               0         0.01         0.01                0          0.02
#> 3               0         0.01         0.01                0          0.01
#> 4               0         0.01         0.01                0          0.01
#> 5               0         0.01         0.01                0          0.01
#> 6               0         0.01         0.01                0          0.01
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1          0.01                 0         0.01         0.01                0
#> 2          0.02                 0         0.01         0.01                0
#> 3          0.01                 0         0.01         0.01                0
#> 4          0.01                 0         0.01         0.01                0
#> 5          0.01                 0         0.01         0.01                0
#> 6          0.01                 0         0.01         0.01                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1        1.51        1.51               0         FIRM            62.60320
#> 2        0.88        0.88               0         FIRM            45.44000
#> 3        0.37        0.37               0         FIRM            57.39007
#> 4        1.05        1.05               0         FIRM            60.99437
#> 5        1.51        1.51               0         FIRM            61.38036
#> 6        1.51        1.51               0         FIRM            62.15683
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.04                 0.04                   0.01
#> 2                0.04                 0.04                   0.01
#> 3                0.04                 0.03                   0.01
#> 4                0.03                 0.03                   0.01
#> 5                0.04                 0.03                   0.01
#> 6                0.04                 0.03                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                3.6800                0.01                 0.01
#> 2                3.4500                0.01                 0.02
#> 3                3.3300                0.01                 0.01
#> 4                8.6043                0.01                 0.01
#> 5                3.3800                0.01                 0.01
#> 6                1.4700                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                  1.51         0.01         0.01
#> 2                   0.01                  0.88         0.02         0.02
#> 3                   0.01                  0.37         0.02         0.02
#> 4                   0.01                  1.05         0.01         0.01
#> 5                   0.01                  1.51         0.01         0.01
#> 6                   0.01                  1.51         0.02         0.02
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.01                   0                  119512.0
#> 2                0.02                   0                  119500.1
#> 3                0.02                   0                  119500.1
#> 4                0.01                   0                  119508.2
#> 5                0.01                   0                  119516.7
#> 6                0.02                   0                  119524.1
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                  90.08492                   98.36091
#> 2                  90.11492                   98.39091
#> 3                  90.14492                   98.41091
#> 4                  90.17492                   98.44091
#> 5                  90.21492                   98.47091
#> 6                  90.24492                   98.49091
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                     30.18106                    6621.867
#> 2                     30.18106                    6623.847
#> 3                     30.19106                    6625.707
#> 4                     30.20106                    6631.861
#> 5                     30.21106                    6632.791
#> 6                     30.21106                    6630.881
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  46.42483                   123.2265
#> 2                  46.42483                   123.2365
#> 3                  46.42483                   123.2365
#> 4                  46.42483                   123.2365
#> 5                  46.42483                   123.2365
#> 6                  46.42483                   123.2365
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     69.52955                    3186.669
#> 2                     69.52955                    3186.849
#> 3                     69.52955                    3186.519
#> 4                     69.52955                    3186.369
#> 5                     69.52955                    3186.679
#> 6                     69.52955                    3187.139
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     35.82                      0.33    NOT_OCD    NOT_MII
#> 2                     35.83                      0.33    NOT_OCD    NOT_MII
#> 3                     35.84                      0.33    NOT_OCD    NOT_MII
#> 4                     35.85                      0.33    NOT_OCD    NOT_MII
#> 5                     35.85                      0.33    NOT_OCD    NOT_MII
#> 6                     35.86                      0.33    NOT_OCD    NOT_MII
options(op)
# }
```
