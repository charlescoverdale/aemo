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
#> Warning: Cache integrity check failed for d15d470c4a6a9a24.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for a8a882bfffda28c7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 64a5dec40bed14bf.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c2d69e7fd374a18f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 09ceddd4b8e23f70.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6080e733a9d5e2ee.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4519db0ecbcd63ed.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 53aeb92b6406fab8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
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
#> # aemo_tbl: AEMO 5min fcas price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-09-19 10:26 UTC 
#> # Rows: 6  Cols: 14
#> 
#>        settlementdate regionid runno intervention raise6secrrp raise60secrrp
#> 1 2026-09-19 19:30:00     NSW1     1            0         0.02          0.02
#> 2 2026-09-19 19:35:00     NSW1     1            0         0.04          0.03
#> 3 2026-09-19 19:40:00     NSW1     1            0         0.04          0.03
#> 4 2026-09-19 19:45:00     NSW1     1            0         0.04          0.03
#> 5 2026-09-19 19:50:00     NSW1     1            0         0.04          0.03
#> 6 2026-09-19 19:55:00     NSW1     1            0         0.04          0.03
#>   raise5minrrp raiseregrrp lower6secrrp lower60secrrp lower5minrrp lowerregrrp
#> 1         0.01           1         0.01          0.01         0.01        1.00
#> 2         0.01           1         0.01          0.01         0.01        1.00
#> 3         0.01           1         0.01          0.01         0.01        1.00
#> 4         0.03           1         0.01          0.01         0.01        1.00
#> 5         0.01           1         0.01          0.10         0.01        1.67
#> 6         0.01           1         0.01          0.01         0.01        1.00
#>   raise1secrrp lower1secrrp
#> 1         0.03            0
#> 2         0.03            0
#> 3         0.03            0
#> 4         0.04            0
#> 5         0.03            0
#> 6         0.04            0
options(op)
# }
```
