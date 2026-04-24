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
#> Warning: Cache integrity check failed for 3fad52aee8677171.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f9f86c5ec3bc31d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0cb48725debe07c2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 98e9dfd33df15a21.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3cf08f0992cb1899.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b8d27770622ed769.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c086e6c1c2723068.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4e16fdb4c3620083.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4bdb9443cb25475a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
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
#> # aemo_tbl: AEMO 5min fcas price NSW1
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 14:38 UTC 
#> # Rows: 6  Cols: 14
#> 
#>        settlementdate regionid runno intervention raise6secrrp raise60secrrp
#> 1 2026-04-24 23:40:00     NSW1     1            0         0.04          0.03
#> 2 2026-04-24 23:45:00     NSW1     1            0         0.04          0.03
#> 3 2026-04-24 23:50:00     NSW1     1            0         0.04          0.03
#> 4 2026-04-24 23:55:00     NSW1     1            0         0.04          0.03
#> 5 2026-04-25 00:00:00     NSW1     1            0         0.04          0.03
#> 6 2026-04-25 00:05:00     NSW1     1            0         0.04          0.03
#>   raise5minrrp raiseregrrp lower6secrrp lower60secrrp lower5minrrp lowerregrrp
#> 1         0.01        3.00         0.01          0.01         0.01        2.00
#> 2         0.01        3.47         0.01          0.01         0.01        2.00
#> 3         0.02        3.47         0.01          0.01         0.01        1.05
#> 4         0.02        3.47         0.01          0.01         0.01        2.00
#> 5         0.02        3.00         0.01          0.01         0.01        2.00
#> 6         0.01        3.00         0.01          0.01         0.01        1.20
#>   raise1secrrp lower1secrrp
#> 1         0.03            0
#> 2         0.03            0
#> 3         0.03            0
#> 4         0.03            0
#> 5         0.03            0
#> 6         0.03            0
options(op)
# }
```
