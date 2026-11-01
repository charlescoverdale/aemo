# Price and demand forecasts (P5MIN, PREDISPATCH)

Returns AEMO's forecast prices and demand for a NEM region. Two
horizons:

- `"p5min"`: 5-minute-ahead forecast, 12 intervals ahead, published
  every 5 minutes.

- `"predispatch"`: 40-hour-ahead predispatch at 30-minute resolution,
  published every 30 minutes.

## Usage

``` r
aemo_predispatch(
  region,
  start,
  end,
  horizon = c("predispatch", "p5min"),
  run_datetime = NULL
)
```

## Arguments

- region:

  NEM region code.

- start, end:

  Window of forecast run-times.

- horizon:

  One of `"predispatch"` (default) or `"p5min"`.

- run_datetime:

  Optional character or `POSIXct`. A specific `RUN_DATETIME` to pin to.
  `NULL` (default) returns every vintage issued in `[start, end]`.

## Value

An `aemo_tbl`.

## Details

The 7-day predispatch publication was retired when 5-minute settlement
commenced; for longer horizons use
[`aemo_pasa()`](https://charlescoverdale.github.io/aemo/reference/aemo_pasa.md).

**Vintages.** PREDISPATCH and P5MIN forecasts are re-issued every 30 or
5 minutes respectively. Every vintage is archived by its `RUN_DATETIME`.
By default (`run_datetime = NULL`) this function returns all vintages
whose *file* timestamp falls in `[start, end]`, i.e. all the forecasts
*issued* during the window. The `periodid` / `datetime` columns on the
returned rows give each forecast's *target* time.

For forecast-error research (comparing a forecast vintage against the
realised dispatch) pass `run_datetime` to pin a specific vintage:

    # The PREDISPATCH run issued at 15:00 on 1 June 2024 --
    # 80 half-hour-ahead rows covering 15:30 out to 31:30 hours.
    v <- aemo_predispatch("NSW1", start = "2024-06-01", end = "2024-06-02",
                          run_datetime = "2024-06-01 15:00")

This is the vintage-aware pattern used in Prakash (2023) *NEMSEER* (JOSS
8(92) 5883).

## See also

Other forecast:
[`aemo_pasa()`](https://charlescoverdale.github.io/aemo/reference/aemo_pasa.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  p <- aemo_predispatch("NSW1", start = now - 3600, end = now)
  head(p)
})
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/PredispatchIS_Reports/PUBL…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/PredispatchIS_Reports/PUBL…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/PredispatchIS_Reports/PUBL…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/PredispatchIS_Reports/PUBL…
#> 
#> # aemo_tbl: AEMO predispatch NSW1
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-01 14:07 UTC 
#> # Rows: 2  Cols: 20
#> 
#>   predispatchseqno runno solutionstatus spdversion nonphysicallosses
#> 1       2026110139     1              1       <NA>                 0
#> 2       2026110140     1              1       <NA>                 0
#>   totalobjective totalareagenviolation totalinterconnectorviolation
#> 1     9766909608                     0                            0
#> 2    10582818841                     0                            0
#>   totalgenericviolation totalramprateviolation totalunitmwcapacityviolation
#> 1                    10                      0                      496.921
#> 2                    10                      0                      408.137
#>   total5minviolation totalregviolation total6secviolation total60secviolation
#> 1               <NA>              <NA>               <NA>                <NA>
#> 2               <NA>              <NA>               <NA>                <NA>
#>   totalasprofileviolation totalenergyconstrviolation totalenergyofferviolation
#> 1                       0                          0                         0
#> 2                       0                          0                         0
#>           lastchanged intervention
#> 1 2026/11/01 23:01:34            0
#> 2 2026/11/01 23:31:35            0
options(op)
# }
```
