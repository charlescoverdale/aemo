# Wholesale electricity prices

Returns 5-minute dispatch prices or 30-minute trading prices for a NEM
region over a specified window. Filters intervention runs by default so
the returned prices are the market clearing prices used in settlement.

## Usage

``` r
aemo_price(
  region,
  start,
  end,
  interval = c("5min", "30min"),
  market = c("energy", "fcas"),
  intervention = FALSE
)
```

## Source

AEMO NEMweb <http://nemweb.com.au>, AEMO Copyright Permissions Notice.

## Arguments

- region:

  One of `"NSW1"`, `"QLD1"`, `"SA1"`, `"TAS1"`, `"VIC1"`. Accepts a
  vector.

- start, end:

  Start and end times (inclusive). Character (parsed as AEST) or
  `POSIXct`.

- interval:

  One of `"5min"` (default) or `"30min"`.

- market:

  One of `"energy"` (default, returns RRP) or `"fcas"` (returns the FCAS
  service RRPs).

- intervention:

  Logical. `FALSE` (default) returns only the market pricing run; `TRUE`
  returns both market and physical runs, with the `intervention` column
  preserved.

## Value

An `aemo_tbl`. Key columns include `settlementdate` (POSIXct AEST),
`regionid`, `rrp` (AUD/MWh, energy) or the FCAS service RRPs (AUD/MW),
and `intervention`.

## Details

**Timestamps** are AEST (UTC+10, no daylight savings) to match AEMO's
market clock. See the package-level documentation for the period-ending
timestamp convention (a row stamped 00:05 is the 5-minute period ending
at 00:05).

**Intervention.** `DISPATCHPRICE` contains both market pricing runs
(`INTERVENTION = 0`) and physical / intervention runs
(`INTERVENTION = 1`). The default filters to market runs. Pass
`intervention = TRUE` to get both.

**30-minute settlement and the 5MS transition.** Before 1 October 2021
the NEM settled on 30-minute trading prices from `TRADINGPRICE`
(TRADINGIS). On 1 October 2021 five-minute settlement (5MS) commenced
and settlement moved to native 5-minute prices. When
`interval = "30min"`:

- For the pre-5MS period (`start < 2021-10-01`): prices are read from
  TRADINGIS (`TRADINGPRICE`).

- For the post-5MS period: prices are derived by taking the arithmetic
  mean of the six 5-minute dispatch prices within each 30-minute trading
  interval, consistent with how AEMO calculates the `TRADINGPRICE`
  column in TradingIS post-5MS.

**Data availability.** NEMweb Current-directory files retain the last
~30 days of 5-minute dispatch files. Historical queries use the Archive
daily-rollup files automatically; for queries older than the Archive
window, use
[`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md)
with an MMSDM URL directly.

## See also

Other price:
[`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  p <- aemo_price("NSW1", now - 3600, now)
  head(p)
})
#> Error in aemo_nemweb_ls(path) : NEMweb returned HTTP 403 for
#> <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/>.
options(op)
# }
```
