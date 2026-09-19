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
#> Warning: Cache integrity check failed for 521c3ebd63a722f9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b3c0151c599da35.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 55237c7ddeaa8ce7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3567538254aae775.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7ff46adf86691433.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6287474405ad3d0f.zip; re-downloading.
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
#> # Retrieved: 2026-09-19 11:09 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-09-19 20:10:00     1     NSW1      20260919194            0 84.41109   0
#> 2 2026-09-19 20:15:00     1     NSW1      20260919195            0 81.84152   0
#> 3 2026-09-19 20:20:00     1     NSW1      20260919196            0 87.01265   0
#> 4 2026-09-19 20:25:00     1     NSW1      20260919197            0 84.67000   0
#> 5 2026-09-19 20:30:00     1     NSW1      20260919198            0 85.89000   0
#> 6 2026-09-19 20:35:00     1     NSW1      20260919199            0 82.95000   0
#>        rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1 84.41109       0                   0 2026/09/19 20:05:04         0.09
#> 2 81.84152       0                   0 2026/09/19 20:10:05         0.09
#> 3 87.01265       0                   0 2026/09/19 20:15:05         0.09
#> 4    84.67       0                   0 2026/09/19 20:20:05         0.04
#> 5    85.89       0                   0 2026/09/19 20:25:05         0.07
#> 6    82.95       0                   0 2026/09/19 20:30:06         0.04
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.09                0          0.09          0.09                 0
#> 2         0.09                0          0.03          0.03                 0
#> 3         0.09                0          0.03          0.03                 0
#> 4         0.04                0          0.03          0.03                 0
#> 5         0.07                0          0.03          0.03                 0
#> 6         0.04                0          0.03          0.03                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.03         0.03                0        1.00           1
#> 2         0.03         0.03                0        1.00           1
#> 3         0.01         0.01                0        1.28        1.28
#> 4         0.03         0.03                0        1.00           1
#> 5         0.03         0.03                0        1.00           1
#> 6         0.03         0.03                0        1.00           1
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
#> 1           1           1               0         FIRM            84.41109
#> 2           1           1               0         FIRM            81.84152
#> 3           1           1               0         FIRM            87.01265
#> 4           1           1               0         FIRM            84.67000
#> 5           1           1               0         FIRM            85.89000
#> 6           1           1               0         FIRM            82.95000
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.09                 0.09                   0.03
#> 2                0.09                 0.03                   0.03
#> 3                0.09                 0.03                   0.01
#> 4                0.04                 0.03                   0.03
#> 5                0.07                 0.03                   0.03
#> 6                0.04                 0.03                   0.03
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  1.00                0.01                 0.01
#> 2                  1.00                0.01                 0.01
#> 3                  1.28                0.01                 0.01
#> 4                  1.00                0.01                 0.01
#> 5                  1.00                0.01                 0.01
#> 6                  1.00                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                     1         0.04         0.04
#> 2                   0.01                     1         0.04         0.04
#> 3                   0.01                     1         0.04         0.04
#> 4                   0.01                     1         0.04         0.04
#> 5                   0.01                     1         0.04         0.04
#> 6                   0.01                     1         0.04         0.04
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.04                   0                  103831.1
#> 2                0.04                   0                  103841.5
#> 3                0.04                   0                  103854.8
#> 4                0.04                   0                  103863.4
#> 5                0.04                   0                  103877.9
#> 6                0.04                   0                  103885.3
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                     52.01                      44.71
#> 2                     52.06                      44.70
#> 3                     52.11                      44.70
#> 4                     52.11                      44.69
#> 5                     52.14                      44.68
#> 6                     52.14                      44.68
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                     17.92886                    5435.427
#> 2                     17.94886                    5431.447
#> 3                     17.94886                    5429.727
#> 4                     17.96886                    5427.727
#> 5                     17.98886                    5428.717
#> 6                     18.00886                    5426.717
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                  49.17733                   116.2799
#> 2                  49.17733                   116.2799
#> 3                  49.17733                   116.2799
#> 4                  49.17733                   116.2799
#> 5                  49.17733                   116.2799
#> 6                  49.17733                   116.2799
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     277.5495                    3053.739
#> 2                     277.5495                    3053.069
#> 3                     277.5495                    3053.069
#> 4                     277.5495                    3053.069
#> 5                     277.5495                    3053.069
#> 6                     277.5495                    3053.069
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     30.85                      1.08    NOT_OCD    NOT_MII
#> 2                     30.87                      1.08    NOT_OCD    NOT_MII
#> 3                     30.89                      1.08    NOT_OCD    NOT_MII
#> 4                     30.91                      1.08    NOT_OCD    NOT_MII
#> 5                     30.93                      1.08    NOT_OCD    NOT_MII
#> 6                     30.95                      1.08    NOT_OCD    NOT_MII
options(op)
# }
```
