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
#> [1] "/tmp/Rtmpxs99ZC"
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
#> 1 bslib-71d7f13118c36706c39339f77436fb7b       4096 2026-05-31 19:34:00
#> 2                                downlit       4096 2026-05-31 19:34:02
#> 
options(op)
# }
```
