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
#> Warning: Cache integrity check failed for 98e9dfd33df15a21.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3cf08f0992cb1899.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b8d27770622ed769.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c086e6c1c2723068.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4e16fdb4c3620083.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4bdb9443cb25475a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6760faea8191a6ab.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4eb374b32a7583ee.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 57739fae4be45748.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for bf699208061e19ba.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 93cbae8191856f96.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-24 14:37 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-04-24 23:40:00     1     VIC1      20260424236            0     4701.02
#> 2 2026-04-24 23:45:00     1     VIC1      20260424237            0     4636.54
#> 3 2026-04-24 23:50:00     1     VIC1      20260424238            0     4589.01
#> 4 2026-04-24 23:55:00     1     VIC1      20260424239            0     4565.08
#> 5 2026-04-25 00:00:00     1     VIC1      20260424240            0     4510.81
#> 6 2026-04-25 00:05:00     1     VIC1      20260424241            0     4513.70
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            10627.29          1384            -30                5752.61
#> 2            10588.74          1384            -33                5689.18
#> 3            10552.16          1384            -38                5570.18
#> 4            10497.73          1384            -41                5521.79
#> 5            10484.11          1384            -34                5444.46
#> 6            10427.07          1384            -24                5401.15
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1               27        1024.59                0              <NA>
#> 2               15        1037.64                0              <NA>
#> 3               14         967.17                0              <NA>
#> 4                0         956.70                0              <NA>
#> 5                0         933.64                0              <NA>
#> 6                0         887.45                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                     66                <NA>              <NA>
#> 2            <NA>                     74                <NA>              <NA>
#> 3            <NA>                     74                <NA>              <NA>
#> 4            <NA>                     76                <NA>              <NA>
#> 5            <NA>                     65                <NA>              <NA>
#> 6            <NA>                     54                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                      68                 <NA>
#> 2             <NA>                      70                 <NA>
#> 3             <NA>                      69                 <NA>
#> 4             <NA>                      70                 <NA>
#> 5             <NA>                      69                 <NA>
#> 6             <NA>                      59                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                  56.00                <NA>
#> 2              <NA>            <NA>                  56.00                <NA>
#> 3              <NA>            <NA>                  56.26                <NA>
#> 4              <NA>            <NA>                  58.00                <NA>
#> 5              <NA>            <NA>                  56.00                <NA>
#> 6              <NA>            <NA>                  60.00                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 220.94                <NA>
#> 2              <NA>            <NA>                 215.62                <NA>
#> 3              <NA>            <NA>                 236.00                <NA>
#> 4              <NA>            <NA>                 254.21                <NA>
#> 5              <NA>            <NA>                 242.00                <NA>
#> 6              <NA>            <NA>                 198.00                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  311.85
#> 2               <NA>             <NA>                  317.04
#> 3               <NA>             <NA>                  357.05
#> 4               <NA>             <NA>                  359.56
#> 5               <NA>             <NA>                  358.14
#> 6               <NA>             <NA>                  276.00
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
#> 1                    267                <NA>              <NA>           <NA>
#> 2                    267                <NA>              <NA>           <NA>
#> 3                    267                <NA>              <NA>           <NA>
#> 4                    267                <NA>              <NA>           <NA>
#> 5                    267                <NA>              <NA>           <NA>
#> 6                    265                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1                5.70961 2026/04/24 23:35:07     4852.1523       4847.24
#> 2               -1.31510 2026/04/24 23:40:06     4824.8583       4773.96
#> 3               -3.99641 2026/04/24 23:45:07    4776.85372       4726.78
#> 4               -3.79479 2026/04/24 23:50:07    4748.62448       4690.87
#> 5               -2.50981 2026/04/24 23:55:07    4680.50839       4637.45
#> 6               -7.26399 2026/04/25 00:00:07    4666.82137       4639.81
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                  53.0             <NA>        <NA>
#> 2           <NA>                  35.0             <NA>        <NA>
#> 3           <NA>                  48.0             <NA>        <NA>
#> 4           <NA>                  48.0             <NA>        <NA>
#> 5           <NA>                  35.0             <NA>        <NA>
#> 6           <NA>                  29.1             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    69             <NA>        <NA>
#> 2           <NA>                    59             <NA>        <NA>
#> 3           <NA>                    59             <NA>        <NA>
#> 4           <NA>                    59             <NA>        <NA>
#> 5           <NA>                    69             <NA>        <NA>
#> 6           <NA>                    69             <NA>        <NA>
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
#> 1                        1140                         1192
#> 2                        1140                         1190
#> 3                        1079                         1100
#> 4                        1080                         1100
#> 5                        1141                         1192
#> 6                        1081                         1102
#>   raise5minactualavailability raiseregactualavailability
#> 1                        1169                   276.9375
#> 2                        1166                   251.2500
#> 3                        1078                   330.0000
#> 4                        1077                   171.0938
#> 5                        1166                   378.6875
#> 6                        1074                   290.0000
#>   lower6secactualavailability lower60secactualavailability
#> 1                         759                          799
#> 2                         651                          691
#> 3                         759                          799
#> 4                         761                          801
#> 5                         651                          691
#> 6                         653                          693
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         799                  1166.6866       <NA>       <NA>
#> 2                         696                   793.2500       <NA>       <NA>
#> 3                         804                  1183.2491       <NA>       <NA>
#> 4                         806                  1195.8428       <NA>       <NA>
#> 5                         691                   993.8116       <NA>       <NA>
#> 6                         693                   904.1553       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen       uigf
#> 1                    313.2271               5160.467 2835.28683
#> 2                    315.1051               5089.065 2787.74077
#> 3                    317.1442               5043.924 2753.16398
#> 4                    310.5396               5001.410 2691.73311
#> 5                    316.7043               4954.154 2683.11377
#> 6                    323.2782               4963.088 2630.06912
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               2494.607                 217.67369             0   2835.28683
#> 2               2445.178                 193.71473             0   2787.74077
#> 3               2343.176                  86.83153             0   2753.16398
#> 4               2311.787                  60.65334             0   2691.73311
#> 5               2253.457                   0.00000             0   2683.11377
#> 6               2370.994                 158.67308             0   2630.06912
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          2494.607                     0
#> 2                  0          2445.178                     0
#> 3                  0          2343.176                     0
#> 4                  0          2311.787                     0
#> 5                  0          2253.457                     0
#> 6                  0          2370.994                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1            217.67369             0             0              0
#> 2            193.71473             0             0              0
#> 3             86.83153             0             0              0
#> 4             60.65334             0             0              0
#> 5              0.00000             0             0              0
#> 6            158.67308             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                    230                   4.24                         518
#> 2                    230                   0.00                         517
#> 3                    230                   8.03                         518
#> 4                    230                   8.10                         517
#> 5                    230                   7.91                         518
#> 6                    230                   8.22                         518
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         664                     0             2835.287
#> 2                         556                     0             2787.741
#> 3                         664                     0             2753.164
#> 4                         666                     0             2691.733
#> 5                         556                     0             2683.114
#> 6                         558                     0             2630.069
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         206.020880          1384           301                 0
#> 2         205.401560          1384           308                 0
#> 3         207.655690          1384           306                 0
#> 4           207.8742          1384           313                 0
#> 5         205.581060          1384           308                 0
#> 6         205.086990          1384           303                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                 27                 206.203530   4701.02
#> 2                 15                 204.590750   4636.54
#> 3                 14                 206.839490   4589.01
#> 4                  0                 207.565970   4565.08
#> 5                  0                   206.6797   4510.81
#> 6                  0                 205.731390   4513.70
options(op)
# }
```
