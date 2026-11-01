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
#> [1] "/tmp/Rtmpfutd1Q"
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
#> 1 bslib-7db53ff92ec092c0dbca0588320fd109       4096 2026-11-01 14:06:27
#> 2                                downlit       4096 2026-11-01 14:06:29
#> 
options(op)
# }
```
