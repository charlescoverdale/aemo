# Clear the aemo cache

Clear the aemo cache

## Usage

``` r
aemo_clear_cache()
```

## Value

Invisibly returns `NULL`.

## See also

Other configuration:
[`aemo_cache_info()`](https://charlescoverdale.github.io/aemo/reference/aemo_cache_info.md),
[`aemo_throttle()`](https://charlescoverdale.github.io/aemo/reference/aemo_throttle.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
aemo_clear_cache()
#> Removed 2 cached files from /tmp/RtmpL4FEAF.
options(op)
# }
```
