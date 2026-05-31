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
#> Warning: Cache integrity check failed for 3f56818bb5eea614.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for d6b0b4298a465e05.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 93fee4da5ddfa943.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8ebb2ba0e080d2eb.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 17fccce9610ae713.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4b476ff5e5500c00.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4d70dbb3cf3a809b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ffc3d936e0771d14.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 85fc8f16df70eb3a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9f17e7a6c3a5c009.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ef36a3a05f52fbeb.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 108141fbc018e790.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 10a37f924a603620.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f1a19fc74c516980.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-31 19:34 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-06-01 04:35:00     1     VIC1      20260601007            0     4675.33
#> 2 2026-06-01 04:40:00     1     VIC1      20260601008            0     4624.98
#> 3 2026-06-01 04:45:00     1     VIC1      20260601009            0     4690.12
#> 4 2026-06-01 04:50:00     1     VIC1      20260601010            0     4721.53
#> 5 2026-06-01 04:55:00     1     VIC1      20260601011            0     4740.57
#> 6 2026-06-01 05:00:00     1     VIC1      20260601012            0     4781.31
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            8881.485           928             14                5257.48
#> 2            8900.753           928             19                5215.11
#> 3            8939.057           928             20                5308.36
#> 4            8928.649           928             23                5304.65
#> 5            8879.170           928             29                5254.69
#> 6            8864.517           928             30                5238.27
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1           165.61         416.54                0              <NA>
#> 2           202.00         388.12                0              <NA>
#> 3           219.00         399.24                0              <NA>
#> 4           130.00         453.12                0              <NA>
#> 5           103.00         411.11                0              <NA>
#> 6           119.00         337.96                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                     69                <NA>              <NA>
#> 2            <NA>                     77                <NA>              <NA>
#> 3            <NA>                     77                <NA>              <NA>
#> 4            <NA>                     77                <NA>              <NA>
#> 5            <NA>                     77                <NA>              <NA>
#> 6            <NA>                     77                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                      91                 <NA>
#> 2             <NA>                      96                 <NA>
#> 3             <NA>                      89                 <NA>
#> 4             <NA>                      89                 <NA>
#> 5             <NA>                      89                 <NA>
#> 6             <NA>                      89                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                     71                <NA>
#> 2              <NA>            <NA>                     71                <NA>
#> 3              <NA>            <NA>                     69                <NA>
#> 4              <NA>            <NA>                     69                <NA>
#> 5              <NA>            <NA>                     69                <NA>
#> 6              <NA>            <NA>                     69                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 121.51                <NA>
#> 2              <NA>            <NA>                 120.00                <NA>
#> 3              <NA>            <NA>                 117.00                <NA>
#> 4              <NA>            <NA>                 114.00                <NA>
#> 5              <NA>            <NA>                 184.00                <NA>
#> 6              <NA>            <NA>                 117.00                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     115
#> 2               <NA>             <NA>                     115
#> 3               <NA>             <NA>                     163
#> 4               <NA>             <NA>                     171
#> 5               <NA>             <NA>                     181
#> 6               <NA>             <NA>                     110
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
#> 1                  86.00                <NA>              <NA>           <NA>
#> 2                  87.00                <NA>              <NA>           <NA>
#> 3                 129.00                <NA>              <NA>           <NA>
#> 4                 143.00                <NA>              <NA>           <NA>
#> 5                 147.00                <NA>              <NA>           <NA>
#> 6                 135.22                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               -1.07791 2026/06/01 04:30:02    4870.17606       4923.17
#> 2               -5.88651 2026/06/01 04:35:01    4867.12912       4902.97
#> 3               -3.29073 2026/06/01 04:40:02     4955.4057       4992.13
#> 4               -3.48700 2026/06/01 04:45:02    5000.75995       4939.88
#> 5                1.94523 2026/06/01 04:50:02    4920.89409       4929.02
#> 6                3.90194 2026/06/01 04:55:02    4938.16189       4986.04
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    59             <NA>        <NA>
#> 2           <NA>                    93             <NA>        <NA>
#> 3           <NA>                    54             <NA>        <NA>
#> 4           <NA>                    60             <NA>        <NA>
#> 5           <NA>                    59             <NA>        <NA>
#> 6           <NA>                    60             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    33             <NA>        <NA>
#> 2           <NA>                    20             <NA>        <NA>
#> 3           <NA>                    20             <NA>        <NA>
#> 4           <NA>                    20             <NA>        <NA>
#> 5           <NA>                    23             <NA>        <NA>
#> 6           <NA>                    25             <NA>        <NA>
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
#> 1                     956.000                      991.000
#> 2                     967.000                     1000.000
#> 3                    1003.462                     1041.693
#> 4                    1018.000                     1043.000
#> 5                    1017.000                     1053.000
#> 6                     951.000                      981.000
#>   raise5minactualavailability raiseregactualavailability
#> 1                     964.000                   550.0000
#> 2                     979.000                   543.0000
#> 3                    1019.693                   512.6929
#> 4                    1020.000                   546.0000
#> 5                    1032.000                   529.0000
#> 6                     959.000                   499.7779
#>   lower6secactualavailability lower60secactualavailability
#> 1                         636                          657
#> 2                         684                          725
#> 3                         636                          657
#> 4                         634                          655
#> 5                         634                          655
#> 6                         629                          650
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         657                   570.1562       <NA>       <NA>
#> 2                         735                   788.4414       <NA>       <NA>
#> 3                         667                   568.0000       <NA>       <NA>
#> 4                         665                   772.1562       <NA>       <NA>
#> 5                         665                   574.1562       <NA>       <NA>
#> 6                         660                   765.0000       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    49.64157               4972.812 850.48476
#> 2                    49.39244               4952.362 869.75316
#> 3                    52.35580               5044.486  908.0571
#> 4                    48.65037               4988.530 897.64944
#> 5                    46.53446               4975.554 848.17025
#> 6                    48.80009               5034.840 834.51745
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               850.4848                         0             0    850.48476
#> 2               869.1969                        15             0    869.75316
#> 3               908.0571                         0             0     908.0571
#> 4               897.6494                         0             0    897.64944
#> 5               847.6866                        15             0    848.17025
#> 6               831.2700                        15             0    834.51745
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          850.4848                     0
#> 2                  0          869.1969                     0
#> 3                  0          908.0571                     0
#> 4                  0          897.6494                     0
#> 5                  0          847.6866                     0
#> 6                  0          831.2700                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                   15             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                   15             0             0              0
#> 6                   15             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                     66                      0                         417
#> 2                     67                      0                         418
#> 3                    109                      0                         460
#> 4                    123                      0                         474
#> 5                    127                      0                         478
#> 6                     62                      0                         415
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         413                     0             850.4848
#> 2                         421                     0             869.7532
#> 3                         413                     0             908.0571
#> 4                         411                     0             897.6494
#> 5                         411                     0             848.1703
#> 6                         409                     0             834.5175
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         567.515920           928           918                 0
#> 2         582.421350           928           918                 0
#> 3         597.855360           928           918                 0
#> 4         610.423040           928           918                 0
#> 5           618.3725           928           918                 0
#> 6         626.100850           928           917                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1         165.614580                 556.981430   4675.33
#> 2                202                 568.681450   4624.98
#> 3                219                 582.709450   4690.12
#> 4                130                 597.685450   4721.53
#> 5                103                 610.649450   4740.57
#> 6                119                 618.169440   4781.31
options(op)
# }
```
