# Regional electricity demand

Returns 5-minute regional demand from `DISPATCHREGIONSUM`. Three demand
measures are supported, aligned with AEMO's Demand Terms taxonomy:

## Usage

``` r
aemo_demand(
  region,
  start,
  end,
  measure = c("operational", "operational_less_snsg", "native"),
  intervention = FALSE
)
```

## Source

AEMO NEMweb, AEMO Copyright Permissions Notice.

## Arguments

- region:

  NEM region code. Vector accepted.

- start, end:

  Window (inclusive), character or POSIXct.

- measure:

  One of `"operational"` (default), `"operational_less_snsg"`, or
  `"native"`.

- intervention:

  Logical. Default `FALSE` filters to market pricing runs.

## Value

An `aemo_tbl` with columns `settlementdate`, `regionid`, `demand_mw`
(the requested measure), plus the underlying DISPATCHREGIONSUM columns
used in the derivation.

## Details

- `"operational"` (default): `TOTALDEMAND`, the grid-measured demand met
  by scheduled and semi-scheduled generation plus net interchange. This
  is the quantity AEMO dispatches.

- `"operational_less_snsg"`: `TOTALDEMAND` minus small non-scheduled
  generation (SS_SOLAR_UIGF + SS_WIND_UIGF where present).

- `"native"`: `TOTALDEMAND` plus estimated rooftop PV generation.
  Closest to end-use consumption. If the rooftop PV component is not
  available in DISPATCHREGIONSUM the function warns and returns
  `TOTALDEMAND`; users should join with
  [`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md)
  for a full native-demand estimate.

Timestamps are AEST (UTC+10, no DST).

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  now <- Sys.time()
  d <- aemo_demand("VIC1", now - 3600, now)
  head(d)
})
#> Warning: Cache integrity check failed for 0faa38abb7b1b0eb.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3bb3714a462ce60e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ea22482a70c0c38b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ca2ede4176c0ab88.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for dd6f61022b493f04.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for bdaa024482966391.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 483f333bf4c3e8f9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 97454525fd1e6df6.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f3003172e9e06b5.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 835a8816869ac35f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ba719dd5c14a0180.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3fad52aee8677171.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f9f86c5ec3bc31d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0cb48725debe07c2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 13:44 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-04-24 22:45:00     1     VIC1      20260424225            0     4620.88
#> 2 2026-04-24 22:50:00     1     VIC1      20260424226            0     4593.48
#> 3 2026-04-24 22:55:00     1     VIC1      20260424227            0     4555.17
#> 4 2026-04-24 23:00:00     1     VIC1      20260424228            0     4542.85
#> 5 2026-04-24 23:05:00     1     VIC1      20260424229            0     4718.17
#> 6 2026-04-24 23:10:00     1     VIC1      20260424230            0     4757.12
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            10543.80          1380            -20                5828.14
#> 2            10618.18          1380            -17                5774.29
#> 3            10584.00          1380            -24                5740.93
#> 4            10658.42          1380            -10                5721.40
#> 5            10753.15          1380             23                5895.27
#> 6            10780.22          1380             37                5880.96
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                8        1199.26                0              <NA>
#> 2                9        1171.81                0              <NA>
#> 3                4        1181.76                0              <NA>
#> 4               17        1161.55                0              <NA>
#> 5               12        1165.10                0              <NA>
#> 6                4        1119.85                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                     87                <NA>              <NA>
#> 2            <NA>                     88                <NA>              <NA>
#> 3            <NA>                     87                <NA>              <NA>
#> 4            <NA>                     83                <NA>              <NA>
#> 5            <NA>                     83                <NA>              <NA>
#> 6            <NA>                     88                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                      77                 <NA>
#> 2             <NA>                      80                 <NA>
#> 3             <NA>                      79                 <NA>
#> 4             <NA>                      69                 <NA>
#> 5             <NA>                      71                 <NA>
#> 6             <NA>                      81                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                     67                <NA>
#> 2              <NA>            <NA>                     74                <NA>
#> 3              <NA>            <NA>                     67                <NA>
#> 4              <NA>            <NA>                     57                <NA>
#> 5              <NA>            <NA>                     57                <NA>
#> 6              <NA>            <NA>                     74                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 203.00                <NA>
#> 2              <NA>            <NA>                 202.00                <NA>
#> 3              <NA>            <NA>                 206.00                <NA>
#> 4              <NA>            <NA>                 202.00                <NA>
#> 5              <NA>            <NA>                 200.00                <NA>
#> 6              <NA>            <NA>                 259.94                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  279.79
#> 2               <NA>             <NA>                  339.00
#> 3               <NA>             <NA>                  341.00
#> 4               <NA>             <NA>                  313.87
#> 5               <NA>             <NA>                  350.00
#> 6               <NA>             <NA>                  357.58
#>   raise60seclocalprice raise60seclocalreq raise60secprice raise60secreq
#> 1                 <NA>               <NA>            <NA>          <NA>
#> 2                 <NA>               <NA>            <NA>          <NA>
#> 3                 <NA>               <NA>            <NA>          <NA>
#> 4                 <NA>               <NA>            <NA>          <NA>
#> 5                 <NA>               <NA>            <NA>          <NA>
#> 6                 <NA>               <NA>            <NA>          <NA>
#>   raise60secsupplyprice raise6secdispatch raise6secimport
#> 1                  <NA>              <NA>            <NA>
#> 2                  <NA>              <NA>            <NA>
#> 3                  <NA>              <NA>            <NA>
#> 4                  <NA>              <NA>            <NA>
#> 5                  <NA>              <NA>            <NA>
#> 6                  <NA>              <NA>            <NA>
#>   raise6seclocaldispatch raise6seclocalprice raise6seclocalreq raise6secprice
#> 1                    221                <NA>              <NA>           <NA>
#> 2                    221                <NA>              <NA>           <NA>
#> 3                    223                <NA>              <NA>           <NA>
#> 4                    237                <NA>              <NA>           <NA>
#> 5                    235                <NA>              <NA>           <NA>
#> 6                    273                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1              -17.70380 2026/04/24 22:40:04    4825.86786       4763.87
#> 2              -12.93167 2026/04/24 22:45:04    4769.93924       4738.55
#> 3              -16.06032 2026/04/24 22:50:04    4737.41761       4693.79
#> 4              -13.47220 2026/04/24 22:55:04     4717.3475       4695.89
#> 5                0.00000 2026/04/24 23:00:05    4832.78839       4860.23
#> 6              -23.73180 2026/04/24 23:05:05       4887.58       4888.18
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    43             <NA>        <NA>
#> 2           <NA>                    43             <NA>        <NA>
#> 3           <NA>                    43             <NA>        <NA>
#> 4           <NA>                    63             <NA>        <NA>
#> 5           <NA>                    58             <NA>        <NA>
#> 6           <NA>                    43             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    90             <NA>        <NA>
#> 2           <NA>                    56             <NA>        <NA>
#> 3           <NA>                    54             <NA>        <NA>
#> 4           <NA>                    51             <NA>        <NA>
#> 5           <NA>                    55             <NA>        <NA>
#> 6           <NA>                    80             <NA>        <NA>
#>   raise5minlocalviolation raisereglocalviolation raise60seclocalviolation
#> 1                    <NA>                   <NA>                     <NA>
#> 2                    <NA>                   <NA>                     <NA>
#> 3                    <NA>                   <NA>                     <NA>
#> 4                    <NA>                   <NA>                     <NA>
#> 5                    <NA>                   <NA>                     <NA>
#> 6                    <NA>                   <NA>                     <NA>
#>   raise6seclocalviolation lower5minlocalviolation lowerreglocalviolation
#> 1                    <NA>                    <NA>                   <NA>
#> 2                    <NA>                    <NA>                   <NA>
#> 3                    <NA>                    <NA>                   <NA>
#> 4                    <NA>                    <NA>                   <NA>
#> 5                    <NA>                    <NA>                   <NA>
#> 6                    <NA>                    <NA>                   <NA>
#>   lower60seclocalviolation lower6seclocalviolation raise5minviolation
#> 1                     <NA>                    <NA>               <NA>
#> 2                     <NA>                    <NA>               <NA>
#> 3                     <NA>                    <NA>               <NA>
#> 4                     <NA>                    <NA>               <NA>
#> 5                     <NA>                    <NA>               <NA>
#> 6                     <NA>                    <NA>               <NA>
#>   raiseregviolation raise60secviolation raise6secviolation lower5minviolation
#> 1              <NA>                <NA>               <NA>               <NA>
#> 2              <NA>                <NA>               <NA>               <NA>
#> 3              <NA>                <NA>               <NA>               <NA>
#> 4              <NA>                <NA>               <NA>               <NA>
#> 5              <NA>                <NA>               <NA>               <NA>
#> 6              <NA>                <NA>               <NA>               <NA>
#>   lowerregviolation lower60secviolation lower6secviolation
#> 1              <NA>                <NA>               <NA>
#> 2              <NA>                <NA>               <NA>
#> 3              <NA>                <NA>               <NA>
#> 4              <NA>                <NA>               <NA>
#> 5              <NA>                <NA>               <NA>
#> 6              <NA>                <NA>               <NA>
#>   raise6secactualavailability raise60secactualavailability
#> 1                        1206                         1225
#> 2                        1206                         1228
#> 3                        1207                         1228
#> 4                        1279                         1329
#> 5                        1280                         1332
#> 6                        1250                         1274
#>   raise5minactualavailability raiseregactualavailability
#> 1                        1197                   420.3438
#> 2                        1198                   429.5938
#> 3                        1199                   401.5625
#> 4                        1299                   481.1562
#> 5                        1300                   516.7500
#> 6                        1241                   436.1250
#>   lower6secactualavailability lower60secactualavailability
#> 1                         770                          810
#> 2                         771                          811
#> 3                         770                          810
#> 4                         760                          800
#> 5                         760                          800
#> 6                         771                          811
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         820                   1203.466       <NA>       <NA>
#> 2                         821                   1001.843       <NA>       <NA>
#> 3                         820                   1205.687       <NA>       <NA>
#> 4                         810                   1002.030       <NA>       <NA>
#> 5                         810                   1188.124       <NA>       <NA>
#> 6                         821                   1185.499       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen       uigf
#> 1                    289.3893               5053.259 2749.80256
#> 2                    292.2409               5030.791 2823.17935
#> 3                    293.8890               4987.679 2795.00491
#> 4                    291.7884               4987.678 2874.42242
#> 5                    292.9042               5153.134 2936.14972
#> 6                    297.7592               5185.939  2970.2222
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               2398.142                 202.55579             0   2749.80256
#> 2               2344.291                 116.41865             0   2823.17935
#> 3               2310.925                  60.22189             0   2795.00491
#> 4               2291.402                  14.10201             0   2874.42242
#> 5               2480.274                 192.01539             0   2936.14972
#> 6               2481.963                 162.03092             0    2970.2222
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          2398.142                     0
#> 2                  0          2344.291                     0
#> 3                  0          2310.925                     0
#> 4                  0          2291.402                     0
#> 5                  0          2480.274                     0
#> 6                  0          2481.963                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1            202.55579             0             0              0
#> 2            116.41865             0             0              0
#> 3             60.22189             0             0              0
#> 4             14.10201             0             0              0
#> 5            192.01539             0             0              0
#> 6            162.03092             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                 225.00                      0                         682
#> 2                 226.00                      1                         684
#> 3                 228.00                      0                         685
#> 4                 219.41                      1                         688
#> 5                 230.00                      1                         689
#> 6                 230.00                      1                         689
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         675                     0             2749.803
#> 2                         676                     0             2823.179
#> 3                         675                     0             2795.005
#> 4                         665                     0             2874.422
#> 5                         665                     0             2936.150
#> 6                         676                     0             2970.222
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         216.583060          1380           308                 0
#> 2         216.398230          1380           304                 0
#> 3         215.687220          1380           298                 0
#> 4         213.481260          1380           293                 0
#> 5         213.009310          1380           325                 0
#> 6         209.413920          1380           318                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  8                   216.3242   4620.88
#> 2                  9                 217.027050   4593.48
#> 3                  4                 216.254210   4555.17
#> 4                 17                 214.666750   4542.85
#> 5                 12                 213.400860   4718.17
#> 6                  4                   209.9913   4757.12
options(op)
# }
```
