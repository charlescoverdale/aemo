# Projected Assessment of System Adequacy (PASA)

Returns short-term (`STPASA`, 1-7 day) or medium-term (`MTPASA`, 2-year)
system adequacy projections.

## Usage

``` r
aemo_pasa(
  horizon = c("short", "medium"),
  region = NULL,
  start = NULL,
  end = NULL
)
```

## Arguments

- horizon:

  One of `"short"` (default) or `"medium"`.

- region:

  Optional NEM region code.

- start, end:

  Optional window of run-times. Defaults to the last 24 hours.

## Value

An `aemo_tbl`.

## See also

Other forecast:
[`aemo_predispatch()`](https://charlescoverdale.github.io/aemo/reference/aemo_predispatch.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())

# STPASA is republished every half hour, so the 24-hour default window
# pulls dozens of files. Pass an explicit narrow window to keep the
# example to a couple of downloads.
try({
  p <- aemo_pasa(horizon = "short", region = "NSW1",
                 start = Sys.time() - as.difftime(1, units = "hours"),
                 end   = Sys.time())
})
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Short_Term_PASA_Reports/PU…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Short_Term_PASA_Reports/PU…
#> 
options(op)
# }
```
