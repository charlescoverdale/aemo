# Gas market data (STTM, DWGM)

Returns Short Term Trading Market (`STTM`, Adelaide, Brisbane, Sydney
hubs) or Declared Wholesale Gas Market (`DWGM`, Victoria) prices and
volumes.

## Usage

``` r
aemo_gas(market = c("sttm", "dwgm"), hub = NULL, start, end)
```

## Arguments

- market:

  One of `"sttm"` (default) or `"dwgm"`.

- hub:

  Optional STTM hub: `"adelaide"`, `"brisbane"`, or `"sydney"`. Ignored
  for DWGM.

- start, end:

  Window.

## Value

An `aemo_tbl`.

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  g <- aemo_gas(market = "sttm", hub = "sydney",
                 start = now - 7 * 86400, end = now)
  head(g)
})
#> Error in aemo_nemweb_ls(path) : NEMweb returned HTTP 403 for
#> <http://nemweb.com.au/Reports/Current/STTM/>.
options(op)
# }
```
