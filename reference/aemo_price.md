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
#> Warning: Cache integrity check failed for 6573637dad592f8a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0c39ccd2bb4fdc51.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cca2b959d5993570.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f97cba749cf2e79b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4322e37732a56d17.zip; re-downloading.
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
#> # Retrieved: 2026-04-28 19:58 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-04-29 05:00:00     1     NSW1      20260429012            0 84.02858   0
#> 2 2026-04-29 05:05:00     1     NSW1      20260429013            0 79.00000   0
#> 3 2026-04-29 05:10:00     1     NSW1      20260429014            0 90.48674   0
#> 4 2026-04-29 05:15:00     1     NSW1      20260429015            0 84.78993   0
#> 5 2026-04-29 05:20:00     1     NSW1      20260429016            0 71.40000   0
#> 6 2026-04-29 05:25:00     1     NSW1      20260429017            0 79.00000   0
#>        rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1 84.02858       0                   0 2026/04/29 04:55:05         0.09
#> 2       79       0                   0 2026/04/29 05:00:05         0.09
#> 3 90.48674       0                   0 2026/04/29 05:05:05         0.09
#> 4 84.78993       0                   0 2026/04/29 05:10:06         0.09
#> 5     71.4       0                   0 2026/04/29 05:15:06         0.09
#> 6       79       0                   0 2026/04/29 05:20:06         0.09
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.09                0          0.15          0.15                 0
#> 2         0.09                0          0.10           0.1                 0
#> 3         0.09                0          0.15          0.15                 0
#> 4         0.09                0          0.10           0.1                 0
#> 5         0.09                0          0.10           0.1                 0
#> 6         0.09                0          0.10           0.1                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.03         0.03                0        3.47        3.47
#> 2         0.03         0.03                0        3.47        3.47
#> 3         0.03         0.03                0        3.47        3.47
#> 4         0.03         0.03                0        3.47        3.47
#> 5         0.01         0.01                0        3.47        3.47
#> 6         0.02         0.02                0        3.47        3.47
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
#> 1        1.62        1.62               0         FIRM            84.02858
#> 2        2.00           2               0         FIRM            79.00000
#> 3        3.61        3.61               0         FIRM            90.48674
#> 4        2.00           2               0         FIRM            84.78993
#> 5        1.62        1.62               0         FIRM            71.40000
#> 6        1.20         1.2               0         FIRM            79.00000
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.09                 0.15                   0.03
#> 2                0.09                 0.10                   0.03
#> 3                0.09                 0.15                   0.03
#> 4                0.09                 0.10                   0.03
#> 5                0.09                 0.10                   0.01
#> 6                0.09                 0.10                   0.02
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  3.47                   0                    0
#> 2                  3.47                   0                    0
#> 3                  3.47                   0                    0
#> 4                  3.47                   0                    0
#> 5                  3.47                   0                    0
#> 6                  3.47                   0                    0
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                      0                  1.62         0.03         0.03
#> 2                      0                  2.00         0.03         0.03
#> 3                      0                  3.61         0.03         0.03
#> 4                      0                  2.00         0.04         0.04
#> 5                      0                  1.62         0.03         0.03
#> 6                      0                  1.20         0.03         0.03
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.03                   0                  110735.4
#> 2                0.03                   0                  110756.9
#> 3                0.03                   0                  110789.5
#> 4                0.04                   0                  110808.8
#> 5                0.03                   0                  110814.7
#> 6                0.03                   0                  110828.2
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                   280.944                   266.2307
#> 2                   280.994                   266.3007
#> 3                   281.044                   266.4207
#> 4                   281.084                   266.4807
#> 5                   281.124                   266.5407
#> 6                   281.164                   266.6107
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                     71.21578                    6625.867
#> 2                     71.23578                    6627.867
#> 3                     71.25578                    6627.347
#> 4                     71.26578                    6627.347
#> 5                     71.25578                    6627.347
#> 6                     71.25578                    6627.137
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  21.05325                   58.61974
#> 2                  21.05325                   58.61974
#> 3                  21.05325                   58.61974
#> 4                  21.05325                   58.61974
#> 5                  21.05325                   58.61974
#> 6                  21.05325                   58.61974
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     39.00356                    3990.933
#> 2                     39.00356                    3992.933
#> 3                     39.00356                    3993.273
#> 4                     39.00356                    3990.333
#> 5                     39.00356                    3988.683
#> 6                     39.00356                    3989.883
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     43.72                      1.23    NOT_OCD    NOT_MII
#> 2                     43.71                      1.23    NOT_OCD    NOT_MII
#> 3                     43.70                      1.23    NOT_OCD    NOT_MII
#> 4                     43.70                      1.23    NOT_OCD    NOT_MII
#> 5                     43.69                      1.23    NOT_OCD    NOT_MII
#> 6                     43.68                      1.23    NOT_OCD    NOT_MII
options(op)
# }
```
