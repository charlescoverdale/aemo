# Inspect the local aemo cache

Inspect the local aemo cache

## Usage

``` r
aemo_cache_info()
```

## Value

A list with `dir`, `n_files`, `size_bytes`, `size_human`, `files`.

## See also

Other configuration:
[`aemo_clear_cache()`](https://charlescoverdale.github.io/aemo/reference/aemo_clear_cache.md),
[`aemo_throttle()`](https://charlescoverdale.github.io/aemo/reference/aemo_throttle.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
aemo_cache_info()
#> $dir
#> [1] "/tmp/Rtmpg09zNt"
#> 
#> $n_files
#> [1] 2
#> 
#> $size_bytes
#> [1] 8192
#> 
#> $size_human
#> [1] "8.0 KB"
#> 
#> $files
#>                                     name size_bytes            modified
#> 1 bslib-e9b2b13fa612f50d23e4850d93d60d01       4096 2026-08-23 17:35:22
#> 2                                downlit       4096 2026-08-23 17:35:25
#> 
options(op)
# }
```
