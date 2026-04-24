# Print an aemo_tbl

Print an aemo_tbl

## Usage

``` r
# S3 method for class 'aemo_tbl'
print(x, ...)
```

## Arguments

- x:

  An `aemo_tbl`.

- ...:

  Passed to the next print method.

## Value

Invisibly returns `x`.

## Examples

``` r
x <- data.frame(settlementdate = Sys.time(), region = "NSW1", rrp = 80)
x <- structure(x, aemo_title = "Demo", aemo_source = "http://nemweb.com.au",
               aemo_licence = "AEMO Copyright Permissions Notice",
               aemo_retrieved = Sys.time(),
               class = c("aemo_tbl", "data.frame"))
print(x)
#> # aemo_tbl: Demo
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 15:25 UTC 
#> # Rows: 1  Cols: 3
#> 
#>        settlementdate region rrp
#> 1 2026-04-24 15:25:24   NSW1  80
```
