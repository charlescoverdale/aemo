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
#> Warning: Cache integrity check failed for 3d68ee95afa8150e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7e04a6690826e6ac.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cfe993541435e59f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4b5cbf73e6f00631.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 829b75b548ad2f5f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f57d2ebe63c497d8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 987a3c03aabfd59f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 9efbd4132ed70868.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7972a9506feaf872.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6573637dad592f8a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 0c39ccd2bb4fdc51.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cca2b959d5993570.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for f97cba749cf2e79b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4322e37732a56d17.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-28 19:13 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-04-29 04:15:00     1     VIC1      20260429003            0     4250.03
#> 2 2026-04-29 04:20:00     1     VIC1      20260429004            0     4264.77
#> 3 2026-04-29 04:25:00     1     VIC1      20260429005            0     4280.41
#> 4 2026-04-29 04:30:00     1     VIC1      20260429006            0     4287.83
#> 5 2026-04-29 04:35:00     1     VIC1      20260429007            0     4281.27
#> 6 2026-04-29 04:40:00     1     VIC1      20260429008            0     4296.55
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            9471.031          1550              5                5024.33
#> 2            9459.986          1550              7                4998.49
#> 3            9456.681          1551              9                4994.88
#> 4            9466.965          1551              9                5005.46
#> 5            9465.573          1551             12                5006.15
#> 6            9472.515          1551             13                5004.92
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1           105.49         668.81                0              <NA>
#> 2           108.00         625.72                0              <NA>
#> 3           116.00         598.47                0              <NA>
#> 4           104.00         613.64                0              <NA>
#> 5            98.00         626.88                0              <NA>
#> 6            90.00         618.37                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                      0                <NA>              <NA>
#> 2            <NA>                      0                <NA>              <NA>
#> 3            <NA>                      0                <NA>              <NA>
#> 4            <NA>                      0                <NA>              <NA>
#> 5            <NA>                      0                <NA>              <NA>
#> 6            <NA>                      0                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                       0                 <NA>
#> 2             <NA>                       0                 <NA>
#> 3             <NA>                       0                 <NA>
#> 4             <NA>                       0                 <NA>
#> 5             <NA>                       0                 <NA>
#> 6             <NA>                       0                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                      0                <NA>
#> 2              <NA>            <NA>                      0                <NA>
#> 3              <NA>            <NA>                      0                <NA>
#> 4              <NA>            <NA>                      0                <NA>
#> 5              <NA>            <NA>                      0                <NA>
#> 6              <NA>            <NA>                      0                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 275.31                <NA>
#> 2              <NA>            <NA>                 317.13                <NA>
#> 3              <NA>            <NA>                 346.11                <NA>
#> 4              <NA>            <NA>                 278.51                <NA>
#> 5              <NA>            <NA>                 247.00                <NA>
#> 6              <NA>            <NA>                 233.78                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  363.00
#> 2               <NA>             <NA>                  414.00
#> 3               <NA>             <NA>                  446.00
#> 4               <NA>             <NA>                  417.82
#> 5               <NA>             <NA>                  410.93
#> 6               <NA>             <NA>                  382.01
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
#> 1                 386.72                <NA>              <NA>           <NA>
#> 2                 444.00                <NA>              <NA>           <NA>
#> 3                 451.18                <NA>              <NA>           <NA>
#> 4                 397.82                <NA>              <NA>           <NA>
#> 5                 388.84                <NA>              <NA>           <NA>
#> 6                 356.91                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               -1.73018 2026/04/29 04:10:02    4327.49006       4384.52
#> 2                0.74453 2026/04/29 04:15:03    4389.63265       4401.47
#> 3                0.44754 2026/04/29 04:20:04    4411.22155       4423.99
#> 4               -0.50313 2026/04/29 04:25:03    4421.95689       4417.84
#> 5               -2.34543 2026/04/29 04:30:04    4409.31169       4404.77
#> 6               -1.32005 2026/04/29 04:35:04    4420.40222       4410.34
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    80             <NA>        <NA>
#> 2           <NA>                    58             <NA>        <NA>
#> 3           <NA>                    78             <NA>        <NA>
#> 4           <NA>                    68             <NA>        <NA>
#> 5           <NA>                    89             <NA>        <NA>
#> 6           <NA>                    83             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    66             <NA>        <NA>
#> 2           <NA>                    69             <NA>        <NA>
#> 3           <NA>                    62             <NA>        <NA>
#> 4           <NA>                    56             <NA>        <NA>
#> 5           <NA>                    75             <NA>        <NA>
#> 6           <NA>                    55             <NA>        <NA>
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
#> 1                    1218.000                     1222.000
#> 2                    1236.000                     1246.000
#> 3                    1238.000                     1249.000
#> 4                    1239.000                     1249.000
#> 5                    1229.948                     1238.922
#> 6                    1249.000                     1262.000
#>   raise5minactualavailability raiseregactualavailability
#> 1                    1225.000                   744.2752
#> 2                    1248.000                   624.0000
#> 3                    1252.000                   597.0000
#> 4                    1251.000                   666.3573
#> 5                    1242.922                   707.1546
#> 6                    1265.000                   766.0784
#>   lower6secactualavailability lower60secactualavailability
#> 1                         880                          881
#> 2                         899                          900
#> 3                         897                          898
#> 4                         901                          902
#> 5                         895                          896
#> 6                         895                          896
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         891                  1130.9982       <NA>       <NA>
#> 2                         910                  1380.9972       <NA>       <NA>
#> 3                         908                  1181.9982       <NA>       <NA>
#> 4                         912                   986.9982       <NA>       <NA>
#> 5                         906                  1401.9972       <NA>       <NA>
#> 6                         906                  1407.9972       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    53.33199               4437.852 489.03101
#> 2                    54.22326               4455.693 477.98553
#> 3                    53.10202               4477.092 474.68075
#> 4                    54.75207               4472.592 484.96456
#> 5                    56.68490               4461.455 483.57274
#> 6                    55.33690               4465.677 489.51522
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               489.0310                         0             0    489.03101
#> 2               477.9855                         0             0    477.98553
#> 3               474.6807                         0             0    474.68075
#> 4               484.9646                         0             0    484.96456
#> 5               483.5727                         0             0    483.57274
#> 6               489.5152                         0             0    489.51522
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          489.0310                     0
#> 2                  0          477.9855                     0
#> 3                  0          474.6807                     0
#> 4                  0          484.9646                     0
#> 5                  0          483.5727                     0
#> 6                  0          489.5152                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                    213                      0                         723
#> 2                    223                      0                         733
#> 3                    225                      0                         734
#> 4                    225                      0                         735
#> 5                    225                      0                         723
#> 6                    225                      0                         734
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         692                     0             489.0310
#> 2                         711                     0             477.9855
#> 3                         709                     0             474.6807
#> 4                         713                     0             484.9646
#> 5                         707                     0             483.5727
#> 6                         707                     0             489.5152
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         767.765690          1550          1555                 0
#> 2         770.199560          1550          1555                 0
#> 3           780.7772          1551          1555                 0
#> 4         787.686320          1551          1555                 0
#> 5         793.916490          1551          1555                 0
#> 6         800.945390          1551          1555                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1         105.486580                 762.752050   4250.03
#> 2                108                 763.027960   4264.77
#> 3                116                 773.206740   4280.41
#> 4                104                 780.506960   4287.83
#> 5                 98                 786.960350   4281.27
#> 6                 90                 794.090230   4296.55
options(op)
# }
```
