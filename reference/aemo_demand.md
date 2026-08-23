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
#> Warning: Cache integrity check failed for 0e2951cf921a0e85.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8fad02e9e2699fb3.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 47f036577fb550b4.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4ad2b1b8db18195b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6bdd24bd99175af0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 00c60f8b0a5bd8bc.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b50cf9bd42706203.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for acf10574eb3eb6e7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7e812257f3b1b363.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8f4aee7951bdaa05.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b75629ed92a8a7d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 622574dedd5c3c53.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 857f4e1cbdbb56f0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-08-23 17:35 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-08-24 02:40:00     1     VIC1      20260823272            0     4628.31
#> 2 2026-08-24 02:45:00     1     VIC1      20260823273            0     4698.14
#> 3 2026-08-24 02:50:00     1     VIC1      20260823274            0     4678.38
#> 4 2026-08-24 02:55:00     1     VIC1      20260823275            0     4599.67
#> 5 2026-08-24 03:00:00     1     VIC1      20260823276            0     4593.58
#> 6 2026-08-24 03:05:00     1     VIC1      20260823277            0     4625.08
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            11758.85          1924            -13                6380.85
#> 2            11799.90          1924            -19                6470.90
#> 3            11849.12          1924            -11                6380.12
#> 4            11849.62          1924            -10                6383.62
#> 5            11855.60          1924            -13                6393.60
#> 6            11859.19          1924            -13                6385.19
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1           460.74        1291.80                0              <NA>
#> 2           412.00        1360.76                0              <NA>
#> 3           330.06        1371.68                0              <NA>
#> 4           351.05        1432.90                0              <NA>
#> 5           364.00        1436.02                0              <NA>
#> 6           495.75        1264.35                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                     26                <NA>              <NA>
#> 2            <NA>                     67                <NA>              <NA>
#> 3            <NA>                     67                <NA>              <NA>
#> 4            <NA>                     70                <NA>              <NA>
#> 5            <NA>                     67                <NA>              <NA>
#> 6            <NA>                     70                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                  113.00                 <NA>
#> 2             <NA>                  110.00                 <NA>
#> 3             <NA>                  136.00                 <NA>
#> 4             <NA>                  132.43                 <NA>
#> 5             <NA>                  137.00                 <NA>
#> 6             <NA>                  132.33                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                  50.68                <NA>
#> 2              <NA>            <NA>                  83.08                <NA>
#> 3              <NA>            <NA>                  75.00                <NA>
#> 4              <NA>            <NA>                  80.00                <NA>
#> 5              <NA>            <NA>                  78.00                <NA>
#> 6              <NA>            <NA>                  79.00                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 164.40                <NA>
#> 2              <NA>            <NA>                 146.00                <NA>
#> 3              <NA>            <NA>                 158.00                <NA>
#> 4              <NA>            <NA>                 251.09                <NA>
#> 5              <NA>            <NA>                 162.58                <NA>
#> 6              <NA>            <NA>                 163.98                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     184
#> 2               <NA>             <NA>                     184
#> 3               <NA>             <NA>                     184
#> 4               <NA>             <NA>                     184
#> 5               <NA>             <NA>                     184
#> 6               <NA>             <NA>                     184
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
#> 1                 158.00                <NA>              <NA>           <NA>
#> 2                 149.16                <NA>              <NA>           <NA>
#> 3                 158.00                <NA>              <NA>           <NA>
#> 4                 162.00                <NA>              <NA>           <NA>
#> 5                 164.00                <NA>              <NA>           <NA>
#> 6                 164.00                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1                9.73697 2026/08/24 02:35:06     5175.5206       5167.86
#> 2               10.74932 2026/08/24 02:40:06    5221.09351       5185.64
#> 3                8.22904 2026/08/24 02:45:05    5150.45014       5088.87
#> 4                9.43419 2026/08/24 02:50:06    5001.04726       5027.71
#> 5               16.55419 2026/08/24 02:55:06    5019.86065       5035.79
#> 6               21.45940 2026/08/24 03:00:07    5047.66946       5180.78
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                 37.00             <NA>        <NA>
#> 2           <NA>                 42.00             <NA>        <NA>
#> 3           <NA>                 27.00             <NA>        <NA>
#> 4           <NA>                 43.74             <NA>        <NA>
#> 5           <NA>                 40.00             <NA>        <NA>
#> 6           <NA>                 35.00             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                   114             <NA>        <NA>
#> 2           <NA>                   101             <NA>        <NA>
#> 3           <NA>                   140             <NA>        <NA>
#> 4           <NA>                   140             <NA>        <NA>
#> 5           <NA>                   140             <NA>        <NA>
#> 6           <NA>                   101             <NA>        <NA>
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
#> 1                      1228.5                       1244.5
#> 2                      1228.0                       1262.0
#> 3                      1113.5                       1147.5
#> 4                      1228.5                       1261.5
#> 5                      1228.5                       1262.5
#> 6                      1182.0                       1217.0
#>   raise5minactualavailability raiseregactualavailability
#> 1                      1203.5                   1249.114
#> 2                      1210.0                   1231.381
#> 3                      1114.5                   1034.000
#> 4                      1225.5                   1233.050
#> 5                      1225.5                   1239.999
#> 6                      1181.0                    833.000
#>   lower6secactualavailability lower60secactualavailability
#> 1                    780.0000                     801.0000
#> 2                    827.0009                     848.0009
#> 3                    812.0000                     833.0000
#> 4                    889.9505                     910.9505
#> 5                    827.0009                     848.0009
#> 6                    719.0000                     740.0000
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                    801.0000                   762.4108       <NA>       <NA>
#> 2                    848.0009                   955.3125       <NA>       <NA>
#> 3                    833.0000                   880.4688       <NA>       <NA>
#> 4                    910.9505                   991.9496       <NA>       <NA>
#> 5                    848.0009                  1013.1562       <NA>       <NA>
#> 6                    740.0000                   890.3125       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen       uigf
#> 1                    185.8224               5353.682 2392.85088
#> 2                    188.6397               5374.280 2381.89664
#> 3                    194.0237               5282.894 2384.12135
#> 4                    194.2635               5221.973 2395.62058
#> 5                    192.7260               5228.516 2405.59903
#> 6                    190.2421               5371.022 2412.18663
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               2392.851                  653.2674             0   2392.85088
#> 2               2381.897                  654.2754             0   2381.89664
#> 3               2384.121                  655.4114             0   2384.12135
#> 4               2395.621                  657.1508             0   2395.62058
#> 5               2405.599                  650.6953             0   2405.59903
#> 6               2412.187                  644.6265             0   2412.18663
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          2392.851                     0
#> 2                  0          2381.897                     0
#> 3                  0          2384.121                     0
#> 4                  0          2395.621                     0
#> 5                  0          2405.599                     0
#> 6                  0          2412.187                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1             653.2674             0             0              0
#> 2             654.2754             0             0              0
#> 3             655.4114             0             0              0
#> 4             657.1508             0             0              0
#> 5             650.6953             0             0              0
#> 6             644.6265             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                 127.63                      0                       678.5
#> 2                 126.62                      0                       678.0
#> 3                  87.00                      0                       563.5
#> 4                 182.00                      0                       677.5
#> 5                 182.00                      0                       677.5
#> 6                 105.00                      0                       632.0
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                    555.0000                     0             2392.851
#> 2                    602.0009                     0             2381.897
#> 3                    587.0000                     0             2384.121
#> 4                    664.9505                     0             2395.621
#> 5                    602.0009                     0             2405.599
#> 6                    494.0000                     0             2412.187
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         927.155190          1924          1239                 0
#> 2         956.218420          1924          1291                 0
#> 3         982.706120          1924          1337                 0
#> 4        1007.317890          1924          1326                 0
#> 5        1034.108060          1924          1322                 0
#> 6        1064.971970          1924          1319                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1         460.744510                 893.031950   4628.31
#> 2         411.999080                 925.515660   4698.14
#> 3           330.0608                 956.716880   4678.38
#> 4         351.049530                   983.4283   4599.67
#> 5         363.999080                1008.182690   4593.58
#> 6         495.751540                1034.736390   4625.08
options(op)
# }
```
