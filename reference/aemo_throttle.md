# Configure request throttling

Controls the delay between successive NEMweb requests. Defaults to 1
second (half a request per second).

## Usage

``` r
aemo_throttle(delay = 1)
```

## Arguments

- delay:

  Numeric. Minimum delay between requests in seconds. Internally this
  becomes `httr2::req_throttle(rate = 1/delay)`.

## Value

Invisibly returns the previous value.

## See also

Other configuration:
[`aemo_cache_info()`](https://charlescoverdale.github.io/aemo/reference/aemo_cache_info.md),
[`aemo_clear_cache()`](https://charlescoverdale.github.io/aemo/reference/aemo_clear_cache.md)

## Examples

``` r
old <- aemo_throttle(0.5)  # 2 requests per second
aemo_throttle(old)         # restore
```
