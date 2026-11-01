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
#> # aemo_tbl: AEMO 5min fcas price NSW1
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-01 14:04 UTC 
#> # Rows: 6  Cols: 14
#> 
#>        settlementdate regionid runno intervention raise6secrrp raise60secrrp
#> 1 2026-11-01 23:05:00     NSW1     1            0         0.02          0.02
#> 2 2026-11-01 23:10:00     NSW1     1            0         0.03          0.02
#> 3 2026-11-01 23:15:00     NSW1     1            0         0.02          0.02
#> 4 2026-11-01 23:20:00     NSW1     1            0         0.02          0.02
#> 5 2026-11-01 23:25:00     NSW1     1            0         0.02          0.02
#> 6 2026-11-01 23:30:00     NSW1     1            0         0.02          0.02
#>   raise5minrrp raiseregrrp lower6secrrp lower60secrrp lower5minrrp lowerregrrp
#> 1         0.01        3.90         0.01          0.01         0.01     1.50000
#> 2         0.01        3.46         0.01          0.01         0.01     2.00000
#> 3         0.01        3.46         0.01          0.01         0.01     2.00000
#> 4         0.01        3.46         0.01          0.01         0.01     0.90451
#> 5         0.01        2.40         0.01          0.01         0.01     2.50000
#> 6         0.01        0.70         0.01          0.01         0.01     1.00000
#>   raise1secrrp lower1secrrp
#> 1         0.01            0
#> 2         0.01            0
#> 3         0.02            0
#> 4         0.01            0
#> 5         0.01            0
#> 6         0.01            0
options(op)
# }
```
