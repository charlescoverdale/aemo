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
#> Warning: Cache integrity check failed for e9ec41c460ab5751.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for d335a52312bb792b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 10cdbd2f8bbebe38.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 8ea03797d3c1e70b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 7a53c2748c4353d9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for 8b392b2aa93f3b0f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Cache integrity check failed for e4490f941a9024bc.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240305_0000000534145909.zip>
#> Warning: Cache integrity check failed for 1c515230981f27af.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240310_0000000534146400.zip>
#> Warning: Cache integrity check failed for b85c8d75d64fee66.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240315_0000000534146910.zip>
#> Warning: Cache integrity check failed for 6c3eba80c42f6a4d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240320_0000000534147387.zip>
#> Warning: Cache integrity check failed for 18cc0591e159ae4b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240325_0000000534148089.zip>
#> Warning: Cache integrity check failed for 8450a41063373ea5.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240330_0000000534148531.zip>
#> Warning: Cache integrity check failed for ddbc74eb78dc8c2b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> ✖ Downloading <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPA…
#> 
#> Warning: Skipping failed download:
#> <http://nemweb.com.au/Reports/CURRENT/Dispatch_SCADA/PUBLIC_DISPATCHSCADA_202608240335_0000000534149101.zip>
#> Error in aemo_nemweb_ls(path) : NEMweb returned HTTP 403 for
#> <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/>.
options(op)
# }
```
