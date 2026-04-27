# Planned and forced network outages

Returns the `NETWORK_OUTAGEDETAIL` table from MMSDM, which records every
planned and forced outage on NEM transmission and distribution network
elements. Outages are a primary driver of binding constraints and price
spikes: when a line or transformer is out of service the network is more
constrained, reducing the thermal limits that appear as RHS values in
DISPATCHCONSTRAINT.

## Usage

``` r
aemo_outages(start, end, element_id = NULL, outage_type = NULL, region = NULL)
```

## Source

AEMO NEMweb MMSDM archive, NETWORK_OUTAGEDETAIL table. AEMO Copyright
Permissions Notice.

## Arguments

- start, end:

  Outage window (inclusive). Filters on `starttime` and `endtime`: any
  outage active during the window is returned. Character or POSIXct.

- element_id:

  Optional character vector of network element IDs. `NULL` returns all
  elements.

- outage_type:

  Optional character. One of `"PLANNED"`, `"FORCED"`, or `NULL` (both).
  Case-insensitive.

- region:

  Optional NEM region code. Filters on the region column where
  available.

## Value

An `aemo_tbl` with columns from NETWORK_OUTAGEDETAIL including
`outageid`, `starttime`, `endtime`, `substationid`, `equipmenttype`,
`equipmentid`, `outagetype`, `regionid`, and `restarttimeunknown`. Exact
column set depends on the MMSDM version.

## Details

**Use case.** Pair with
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
to explain a price spike: `aemo_outages()` tells you which elements were
off-service at the time;
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
tells you which constraints bound; together they answer "why was SA spot
price AUD 15,000 at 17:35?".

## See also

[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)
for the binding constraint shadow prices that these outages drive.

Other dispatch:
[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md),
[`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md),
[`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md),
[`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md),
[`aemo_gencon()`](https://charlescoverdale.github.io/aemo/reference/aemo_gencon.md),
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md),
[`aemo_market_notices()`](https://charlescoverdale.github.io/aemo/reference/aemo_market_notices.md),
[`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md),
[`aemo_spd_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_spd_constraints.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  # Forced outages during a recent high-price period in SA
  o <- aemo_outages(
    start = "2024-03-01",
    end   = "2024-03-02",
    outage_type = "FORCED"
  )
  head(o)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✔ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> # aemo_tbl: NEM network outages (NETWORK_OUTAGEDETAIL)
#> # Source:   https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-27 21:29 UTC 
#> # Rows: 6  Cols: 19
#> 
#>   outageid substationid equipmenttype equipmentid           starttime
#> 1   838526         HWPS            CB 2GTR_1B_220 2017/03/28 02:00:00
#> 2   931778     KEMPS_CK           CAP          C1 2019/01/17 12:30:00
#> 3   936811     KEMPS_CK           CAP          C1 2019/01/17 12:30:00
#> 4   938742     KEMPS_CK           CAP          C1 2019/01/17 12:30:00
#> 5   928099       CH_GDN           CAP        C_61 2019/10/25 07:30:00
#> 6   928099       CH_GDN            CB      CB6534 2019/10/25 07:30:00
#>               endtime       submitteddate outagestatuscode     resubmitreason
#> 1 2025/12/31 17:00:00 2019-12-31 10:00:52           WDRAWN Information Update
#> 2 2024/12/31 18:00:00 2023-12-30 18:24:22           WDRAWN Information Update
#> 3 2024/05/10 15:00:00 2024-03-26 13:17:54           WDRAWN Information Update
#> 4 2024/09/16 15:00:00 2024-04-22 13:06:21           WDRAWN Information Update
#> 5 2024/10/31 07:30:00 2023-10-31 16:29:25           WDRAWN Information Update
#> 6 2024/10/31 07:30:00 2023-10-31 16:29:25           WDRAWN Information Update
#>   resubmitoutageid recalltimeday recalltimenight             lastchanged
#> 1           838529             0               0 2019/12/31 10:13:32.048
#> 2           936811          5940            5940 2024/03/26 13:17:54.161
#> 3           938742          5940            5940 2024/04/22 13:06:21.036
#> 4           948038          5940            5940 2024/08/26 11:01:56.167
#> 5           952659             0               0 2024/10/28 18:26:04.360
#> 6           952659             0               0 2024/10/28 18:26:04.360
#>                  reason issecondary    actual_starttime actual_endtime
#> 1 HV equipt maintenance           0 2017/03/27 23:10:00           <NA>
#> 2 HV equipt maintenance           0 2019/01/17 12:56:00           <NA>
#> 3 HV equipt maintenance           0 2019/01/17 12:56:00           <NA>
#> 4 HV equipt maintenance           0 2019/01/17 12:56:00           <NA>
#> 5 HV equipt maintenance           0 2019/09/23 12:45:00           <NA>
#> 6 HV equipt maintenance           0 2019/09/23 12:45:00           <NA>
#>   companyrefcode elementid
#> 1     1000013149      5540
#> 2      TG_498652     17404
#> 3      TG_498652     17404
#> 4      TG_498652     17404
#> 5        ESP6534      2792
#> 6        ESP6534      7364
options(op)
# }
```
