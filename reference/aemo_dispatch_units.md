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
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 8a5fd3bb102d0b18.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 652501001febf389.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 823e105b610d56f0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for ce9e97cb8bb14cf0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for fb1baa1e44e0a494.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010450_0000000520300424.zip>
#> Warning: Cache integrity check failed for dd9c4916d6f4dc18.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010455_0000000520300855.zip>
#> Warning: Cache integrity check failed for 52c8bc127cbe877a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010500_0000000520301277.zip>
#> Warning: Cache integrity check failed for e86d3130eca85b12.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 8b9d652860d9673c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010510_0000000520302108.zip>
#> Warning: Cache integrity check failed for 8551c896447fd1e1.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010515_0000000520302501.zip>
#> Warning: Cache integrity check failed for bea6c83d2393316d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010520_0000000520302933.zip>
#> Warning: Cache integrity check failed for 96e29a04265cb0a8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202606010525_0000000520303372.zip>
#> Warning: Cache integrity check failed for d6207ca246f69729.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Error in aemo_nemweb_ls(path) : NEMweb returned HTTP 403 for
#> <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/>.
options(op)
# }
```
