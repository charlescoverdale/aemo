# Frequency control ancillary services (FCAS) prices

Returns regional FCAS market prices across the eight contingency
services plus the two regulation services. Ten services are live in the
NEM since R1/L1 Very Fast commenced on 9 October 2023.

## Usage

``` r
aemo_fcas(region, start, end, service = NULL, intervention = FALSE)
```

## Arguments

- region:

  NEM region code.

- start, end:

  Window (inclusive).

- service:

  Optional character vector of service names (e.g. `"RAISE6SEC"`,
  `"LOWER60SEC"`, `"RAISE1SEC"`).

- intervention:

  Logical. See
  [`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md).

## Value

An `aemo_tbl` with one row per interval and columns for each requested
FCAS RRP (AUD/MW).

## Details

Thin wrapper over `aemo_price(..., market = "fcas")`.

## See also

Other price:
[`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  f <- aemo_fcas("NSW1", now - 3600, now)
  head(f)
})
#> Warning: Cache integrity check failed for 663db9a3edd3d6c2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 83734a79445255be.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 2952f1c3f5618caa.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for e99c7150f177de03.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8cc03171fd348de8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 27ec6ef0de574d06.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for a348477d62462e04.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8453898c0a89422e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for e32ba6f18f31464f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
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
#> # aemo_tbl: AEMO 5min fcas price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-27 20:52 UTC 
#> # Rows: 6  Cols: 14
#> 
#>        settlementdate regionid runno intervention raise6secrrp raise60secrrp
#> 1 2026-04-28 05:55:00     NSW1     1            0         0.09          0.15
#> 2 2026-04-28 06:00:00     NSW1     1            0         0.05          0.03
#> 3 2026-04-28 06:05:00     NSW1     1            0         0.05          0.03
#> 4 2026-04-28 06:10:00     NSW1     1            0         0.05          0.03
#> 5 2026-04-28 06:15:00     NSW1     1            0         0.09          0.09
#> 6 2026-04-28 06:20:00     NSW1     1            0         0.09          0.09
#>   raise5minrrp raiseregrrp lower6secrrp lower60secrrp lower5minrrp lowerregrrp
#> 1         0.01        2.64            0             0            0        4.94
#> 2         0.01        2.64            0             0            0        0.00
#> 3         0.01        3.47            0             0            0        0.00
#> 4         0.01        3.47            0             0            0        2.00
#> 5         0.02        2.64            0             0            0        1.00
#> 6         0.03        3.47            0             0            0        1.20
#>   raise1secrrp lower1secrrp
#> 1         0.03            0
#> 2         0.03            0
#> 3         0.04            0
#> 4         0.03            0
#> 5         0.03            0
#> 6         0.03            0
options(op)
# }
```
