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
#> Warning: Cache integrity check failed for eaa634678b4a2bca.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cd4602a6994b6b4c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
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
#> # aemo_tbl: AEMO 5min fcas price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-04 19:19 UTC 
#> # Rows: 6  Cols: 14
#> 
#>        settlementdate regionid runno intervention raise6secrrp raise60secrrp
#> 1 2026-05-05 04:20:00     NSW1     1            0         0.05          0.03
#> 2 2026-05-05 04:25:00     NSW1     1            0         0.05          0.03
#> 3 2026-05-05 04:30:00     NSW1     1            0         0.04          0.03
#> 4 2026-05-05 04:35:00     NSW1     1            0         0.04          0.03
#> 5 2026-05-05 04:40:00     NSW1     1            0         0.04          0.03
#> 6 2026-05-05 04:45:00     NSW1     1            0         0.04          0.03
#>   raise5minrrp raiseregrrp lower6secrrp lower60secrrp lower5minrrp lowerregrrp
#> 1         0.02        3.47         0.01          0.01         0.01        1.00
#> 2         0.02        3.60         0.01          0.03         0.01        1.00
#> 3         0.01        3.47         0.01          0.10         0.01        1.00
#> 4         0.02        3.47         0.01          0.10         0.01        1.51
#> 5         0.02        3.60         0.01          0.01         0.01        1.51
#> 6         0.01        3.58         0.01          0.10         0.01        1.51
#>   raise1secrrp lower1secrrp
#> 1         0.03         0.01
#> 2         0.03         0.01
#> 3         0.03         0.00
#> 4         0.03         0.00
#> 5         0.04         0.01
#> 6         0.03         0.01
options(op)
# }
```
