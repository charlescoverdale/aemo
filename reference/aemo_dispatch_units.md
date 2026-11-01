# Per-DUID dispatch output

Returns 5-minute generator output for one or more DUIDs. Three measures
are available:

## Usage

``` r
aemo_dispatch_units(
  duid = NULL,
  start,
  end,
  measure = c("scada_mw", "target_mw", "both")
)
```

## Arguments

- duid:

  Optional character vector of DUIDs. `NULL` returns all generators.

- start, end:

  Window (inclusive).

- measure:

  One of `"scada_mw"` (default), `"target_mw"`, or `"both"`.

## Value

An `aemo_tbl` with columns `settlementdate`, `duid`, and the requested
measure(s).

## Details

- `"scada_mw"` (default): actual metered output from
  `DISPATCH_UNIT_SCADA` (`SCADAVALUE`).

- `"target_mw"`: dispatch target from `DISPATCHLOAD` (`TOTALCLEARED`).
  This is the MW AEMO *asked* the unit to produce at the end of the
  interval.

- `"both"`: returns `SCADAVALUE`, `INITIALMW` (SCADA at the start of the
  interval) and `TOTALCLEARED` (target at the end) in a single row per
  DUID per interval. Use this for ramp-trajectory research: the ramp
  applied during the interval is the straight line from `INITIALMW` to
  `TOTALCLEARED`.

Timestamps are AEST (UTC+10, no DST).

## See also

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_outages()`](https://charlescoverdale.github.io/aemo/reference/aemo_outages.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  # SCADA actual
  d <- aemo_dispatch_units(duid = "BW01", start = now - 3600,
                            end = now)

  # Paired: INITIALMW, TOTALCLEARED, SCADAVALUE (ramp research)
  d_both <- aemo_dispatch_units(duid = "BW01",
                                 start = now - 3600, end = now,
                                 measure = "both")
})
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
#> ℹ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> ✔ Downloading <https://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISP…
#> 
options(op)
# }
```
