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
#> Warning: Cache integrity check failed for 8ebb2ba0e080d2eb.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 17fccce9610ae713.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4b476ff5e5500c00.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4d70dbb3cf3a809b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ffc3d936e0771d14.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 85fc8f16df70eb3a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f17e7a6c3a5c009.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ef36a3a05f52fbeb.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 108141fbc018e790.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 10a37f924a603620.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f1a19fc74c516980.zip; re-downloading.
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
#> # Retrieved: 2026-05-31 19:48 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention     rrp eep
#> 1 2026-06-01 04:50:00     1     NSW1      20260601010            0 55.7598   0
#> 2 2026-06-01 04:55:00     1     NSW1      20260601011            0 56.0600   0
#> 3 2026-06-01 05:00:00     1     NSW1      20260601012            0 56.0600   0
#> 4 2026-06-01 05:05:00     1     NSW1      20260601013            0 45.4400   0
#> 5 2026-06-01 05:10:00     1     NSW1      20260601014            0 56.0600   0
#> 6 2026-06-01 05:15:00     1     NSW1      20260601015            0 56.0600   0
#>       rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1 55.7598       0                   0 2026/06/01 04:45:02         0.04
#> 2   56.06       0                   0 2026/06/01 04:50:02         0.04
#> 3   56.06       0                   0 2026/06/01 04:55:02         0.09
#> 4   45.44       0                   0 2026/06/01 05:00:03         0.04
#> 5   56.06       0                   0 2026/06/01 05:05:02         0.04
#> 6   56.06       0                   0 2026/06/01 05:10:03         0.04
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.04                0          0.03          0.03                 0
#> 2         0.04                0          0.03          0.03                 0
#> 3         0.09                0          0.09          0.09                 0
#> 4         0.04                0          0.04          0.04                 0
#> 5         0.04                0          0.04          0.04                 0
#> 6         0.04                0          0.02          0.02                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        4.98        4.98
#> 2         0.01         0.01                0        3.49        3.49
#> 3         0.01         0.01                0        3.46        3.46
#> 4         0.01         0.01                0        7.80         7.8
#> 5         0.01         0.01                0        3.00           3
#> 6         0.01         0.01                0        4.98        4.98
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0         0.01         0.01                0          0.03
#> 2               0         0.01         0.01                0          0.03
#> 3               0         0.01         0.01                0          0.03
#> 4               0         0.01         0.01                0          0.03
#> 5               0         0.01         0.01                0          0.03
#> 6               0         0.01         0.01                0          0.03
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1          0.03                 0         0.01         0.01                0
#> 2          0.03                 0         0.01         0.01                0
#> 3          0.03                 0         0.01         0.01                0
#> 4          0.03                 0         0.01         0.01                0
#> 5          0.03                 0         0.01         0.01                0
#> 6          0.03                 0         0.01         0.01                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1         1.2         1.2               0         FIRM             55.7598
#> 2         1.2         1.2               0         FIRM             56.0600
#> 3         1.2         1.2               0         FIRM             56.0600
#> 4         1.2         1.2               0         FIRM             45.4400
#> 5         1.2         1.2               0         FIRM             56.0600
#> 6         2.0           2               0         FIRM             56.0600
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.04                 0.03                   0.01
#> 2                0.04                 0.03                   0.01
#> 3                0.09                 0.09                   0.01
#> 4                0.04                 0.04                   0.01
#> 5                0.04                 0.04                   0.01
#> 6                0.04                 0.02                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  4.98                0.01                 0.03
#> 2                  3.49                0.01                 0.03
#> 3                  3.46                0.01                 0.03
#> 4                  7.80                0.01                 0.03
#> 5                  3.00                0.01                 0.03
#> 6                  4.98                0.01                 0.03
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                   1.2         0.04         0.04
#> 2                   0.01                   1.2         0.04         0.04
#> 3                   0.01                   1.2         0.04         0.04
#> 4                   0.01                   1.2         0.04         0.04
#> 5                   0.01                   1.2         0.04         0.04
#> 6                   0.01                   2.0         0.03         0.03
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.04                   0                  193546.2
#> 2                0.04                   0                  193520.6
#> 3                0.04                   0                  193497.4
#> 4                0.04                   0                  193465.5
#> 5                0.04                   0                  193435.7
#> 6                0.03                   0                  193403.3
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                  505.6765                   321.4499
#> 2                  505.6265                   321.3899
#> 3                  505.6265                   321.4399
#> 4                  505.5765                   321.3899
#> 5                  505.5265                   321.3799
#> 6                  505.4765                   321.3099
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                      94.4602                    10267.89
#> 2                      94.4502                    10263.54
#> 3                      94.4502                    10262.02
#> 4                      94.4402                    10262.35
#> 5                      94.4402                    10257.55
#> 6                      94.4302                    10259.07
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                     16.85                    74.2195
#> 2                     16.83                    74.2195
#> 3                     16.81                    74.2195
#> 4                     16.79                    74.2195
#> 5                     16.77                    74.2195
#> 6                     16.76                    74.2195
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     16.85938                    3982.491
#> 2                     16.85938                    3982.491
#> 3                     16.85938                    3982.201
#> 4                     16.85938                    3982.521
#> 5                     16.85938                    3981.721
#> 6                     16.85938                    3982.521
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     74.24                      0.18    NOT_OCD    NOT_MII
#> 2                     74.24                      0.18    NOT_OCD    NOT_MII
#> 3                     74.24                      0.18    NOT_OCD    NOT_MII
#> 4                     74.24                      0.18    NOT_OCD    NOT_MII
#> 5                     74.24                      0.18    NOT_OCD    NOT_MII
#> 6                     74.23                      0.18    NOT_OCD    NOT_MII
options(op)
# }
```
