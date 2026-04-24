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
#> Warning: Cache integrity check failed for 6760faea8191a6ab.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4eb374b32a7583ee.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 57739fae4be45748.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for bf699208061e19ba.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 93cbae8191856f96.zip; re-downloading.
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
#> # Retrieved: 2026-04-24 15:24 UTC 
#> # Rows: 6  Cols: 66
#> 
#>        settlementdate runno regionid dispatchinterval intervention      rrp eep
#> 1 2026-04-25 00:25:00     1     NSW1      20260424245            0 78.81890   0
#> 2 2026-04-25 00:30:00     1     NSW1      20260424246            0 77.06000   0
#> 3 2026-04-25 00:35:00     1     NSW1      20260424247            0 79.90534   0
#> 4 2026-04-25 00:40:00     1     NSW1      20260424248            0 79.00000   0
#> 5 2026-04-25 00:45:00     1     NSW1      20260424249            0 79.00000   0
#> 6 2026-04-25 00:50:00     1     NSW1      20260424250            0 78.43555   0
#>        rop apcflag marketsuspendedflag         lastchanged raise6secrrp
#> 1  78.8189       0                   0 2026/04/25 00:20:01         0.04
#> 2    77.06       0                   0 2026/04/25 00:25:02         0.04
#> 3 79.90534       0                   0 2026/04/25 00:30:02         0.04
#> 4       79       0                   0 2026/04/25 00:35:02         0.04
#> 5       79       0                   0 2026/04/25 00:40:09         0.04
#> 6 78.43555       0                   0 2026/04/25 00:45:10         0.04
#>   raise6secrop raise6secapcflag raise60secrrp raise60secrop raise60secapcflag
#> 1         0.04                0          0.03          0.03                 0
#> 2         0.04                0          0.03          0.03                 0
#> 3         0.04                0          0.02          0.02                 0
#> 4         0.04                0          0.03          0.03                 0
#> 5         0.04                0          0.03          0.03                 0
#> 6         0.04                0          0.03          0.03                 0
#>   raise5minrrp raise5minrop raise5minapcflag raiseregrrp raiseregrop
#> 1         0.01         0.01                0        3.00           3
#> 2         0.01         0.01                0        3.47        3.47
#> 3         0.01         0.01                0        3.00           3
#> 4         0.02         0.02                0        3.00           3
#> 5         0.01         0.01                0        3.47        3.47
#> 6         0.01         0.01                0        3.00           3
#>   raiseregapcflag lower6secrrp lower6secrop lower6secapcflag lower60secrrp
#> 1               0         0.01         0.01                0          0.01
#> 2               0         0.01         0.01                0          0.02
#> 3               0         0.01         0.01                0          0.01
#> 4               0         0.01         0.01                0          0.02
#> 5               0         0.01         0.01                0          0.03
#> 6               0         0.01         0.01                0          0.01
#>   lower60secrop lower60secapcflag lower5minrrp lower5minrop lower5minapcflag
#> 1          0.01                 0         0.01         0.01                0
#> 2          0.02                 0         0.01         0.01                0
#> 3          0.01                 0         0.01         0.01                0
#> 4          0.02                 0         0.01         0.01                0
#> 5          0.03                 0         0.01         0.01                0
#> 6          0.01                 0         0.01         0.01                0
#>   lowerregrrp lowerregrop lowerregapcflag price_status pre_ap_energy_price
#> 1        2.00           2               0         FIRM            78.81890
#> 2        2.00           2               0         FIRM            77.06000
#> 3        2.00           2               0         FIRM            79.90534
#> 4        1.05        1.05               0         FIRM            79.00000
#> 5        1.05        1.05               0         FIRM            79.00000
#> 6        0.99        0.99               0         FIRM            78.43555
#>   pre_ap_raise6_price pre_ap_raise60_price pre_ap_raise5min_price
#> 1                0.04                 0.03                   0.01
#> 2                0.04                 0.03                   0.01
#> 3                0.04                 0.02                   0.01
#> 4                0.04                 0.03                   0.02
#> 5                0.04                 0.03                   0.01
#> 6                0.04                 0.03                   0.01
#>   pre_ap_raisereg_price pre_ap_lower6_price pre_ap_lower60_price
#> 1                  3.00                0.01                 0.01
#> 2                  3.47                0.01                 0.02
#> 3                  3.00                0.01                 0.01
#> 4                  3.00                0.01                 0.02
#> 5                  3.47                0.01                 0.03
#> 6                  3.00                0.01                 0.01
#>   pre_ap_lower5min_price pre_ap_lowerreg_price raise1secrrp raise1secrop
#> 1                   0.01                  2.00         0.03         0.03
#> 2                   0.01                  2.00         0.03         0.03
#> 3                   0.01                  2.00         0.02         0.02
#> 4                   0.01                  1.05         0.03         0.03
#> 5                   0.01                  1.05         0.03         0.03
#> 6                   0.01                  0.99         0.03         0.03
#>   raise1secapcflag lower1secrrp lower1secrop lower1secapcflag
#> 1                0            0            0                0
#> 2                0            0            0                0
#> 3                0            0            0                0
#> 4                0            0            0                0
#> 5                0            0            0                0
#> 6                0            0            0                0
#>   pre_ap_raise1_price pre_ap_lower1_price cumul_pre_ap_energy_price
#> 1                0.03                   0                  112761.6
#> 2                0.03                   0                  112758.6
#> 3                0.02                   0                  112746.8
#> 4                0.03                   0                  112741.0
#> 5                0.03                   0                  112735.2
#> 6                0.03                   0                  112731.2
#>   cumul_pre_ap_raise6_price cumul_pre_ap_raise60_price
#> 1                  353.1181                   275.7714
#> 2                  353.1081                   275.7714
#> 3                  353.0981                   275.7514
#> 4                  353.0881                   275.7414
#> 5                  353.0881                   275.7414
#> 6                  353.0881                   275.7414
#>   cumul_pre_ap_raise5min_price cumul_pre_ap_raisereg_price
#> 1                      65.6779                    7588.384
#> 2                      65.6779                    7588.384
#> 3                      65.6679                    7589.884
#> 4                      65.6779                    7591.384
#> 5                      65.6779                    7591.384
#> 6                      65.6779                    7592.914
#>   cumul_pre_ap_lower6_price cumul_pre_ap_lower60_price
#> 1                   5.81978                   30.03185
#> 2                   5.82978                   30.03185
#> 3                   5.83978                   30.04185
#> 4                   5.83978                   30.05185
#> 5                   5.84978                   30.07185
#> 6                   5.85978                   30.07185
#>   cumul_pre_ap_lower5min_price cumul_pre_ap_lowerreg_price
#> 1                     22.62319                    4458.439
#> 2                     22.62319                    4456.789
#> 3                     22.63319                    4455.229
#> 4                     22.63319                    4452.549
#> 5                     22.64319                    4452.399
#> 6                     22.64319                    4449.399
#>   cumul_pre_ap_raise1_price cumul_pre_ap_lower1_price ocd_status mii_status
#> 1                     55.37                      0.39    NOT_OCD    NOT_MII
#> 2                     55.37                      0.39    NOT_OCD    NOT_MII
#> 3                     55.36                      0.39    NOT_OCD    NOT_MII
#> 4                     55.36                      0.39    NOT_OCD    NOT_MII
#> 5                     55.37                      0.39    NOT_OCD    NOT_MII
#> 6                     55.38                      0.39    NOT_OCD    NOT_MII
options(op)
# }
```
