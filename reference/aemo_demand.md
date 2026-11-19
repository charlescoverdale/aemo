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
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   https://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-11-19 08:26 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-11-19 17:30:00     1     VIC1      20261119162            0     6088.09
#> 2 2026-11-19 17:35:00     1     VIC1      20261119163            0     6128.20
#> 3 2026-11-19 17:40:00     1     VIC1      20261119164            0     6067.80
#> 4 2026-11-19 17:45:00     1     VIC1      20261119165            0     6048.45
#> 5 2026-11-19 17:50:00     1     VIC1      20261119166            0     6030.60
#> 6 2026-11-19 17:55:00     1     VIC1      20261119167            0     6096.00
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            8958.806          1933             11                6288.93
#> 2            8916.538          1932              9                6156.87
#> 3            8920.770          1932              8                6214.95
#> 4            8934.520          1933              7                5759.72
#> 5            8914.283          1938              3                5759.17
#> 6            8903.753          1937              0                6106.43
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                3         197.84                0              <NA>
#> 2                3          25.68                0              <NA>
#> 3                3         144.15                0              <NA>
#> 4                3        -291.73                0              <NA>
#> 5                8        -279.43                0              <NA>
#> 6                3           7.43                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                  79.00                <NA>              <NA>
#> 2            <NA>                  70.00                <NA>              <NA>
#> 3            <NA>                  75.77                <NA>              <NA>
#> 4            <NA>                  72.00                <NA>              <NA>
#> 5            <NA>                 137.42                <NA>              <NA>
#> 6            <NA>                  70.00                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                      69                 <NA>
#> 2             <NA>                      65                 <NA>
#> 3             <NA>                     194                 <NA>
#> 4             <NA>                      68                 <NA>
#> 5             <NA>                     190                 <NA>
#> 6             <NA>                     170                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                     67                <NA>
#> 2              <NA>            <NA>                     60                <NA>
#> 3              <NA>            <NA>                     68                <NA>
#> 4              <NA>            <NA>                     69                <NA>
#> 5              <NA>            <NA>                     66                <NA>
#> 6              <NA>            <NA>                    171                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                    122                <NA>
#> 2              <NA>            <NA>                    128                <NA>
#> 3              <NA>            <NA>                    122                <NA>
#> 4              <NA>            <NA>                    129                <NA>
#> 5              <NA>            <NA>                    135                <NA>
#> 6              <NA>            <NA>                    140                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     118
#> 2               <NA>             <NA>                     118
#> 3               <NA>             <NA>                     110
#> 4               <NA>             <NA>                     120
#> 5               <NA>             <NA>                     119
#> 6               <NA>             <NA>                     126
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
#> 1                     85                <NA>              <NA>           <NA>
#> 2                     83                <NA>              <NA>           <NA>
#> 3                     83                <NA>              <NA>           <NA>
#> 4                     91                <NA>              <NA>           <NA>
#> 5                     85                <NA>              <NA>           <NA>
#> 6                     95                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               18.81202 2026/11/19 17:25:03    6095.23617       6127.67
#> 2               14.89056 2026/11/19 17:30:03    6145.97637        6170.3
#> 3               11.86288 2026/11/19 17:35:04    6093.47371       6112.43
#> 4               11.76947 2026/11/19 17:40:04    6078.36482       6091.87
#> 5               13.09161 2026/11/19 17:45:05    6056.78757       6077.68
#> 6               17.78240 2026/11/19 17:50:04    6135.97443       6143.47
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    10             <NA>        <NA>
#> 2           <NA>                    10             <NA>        <NA>
#> 3           <NA>                     0             <NA>        <NA>
#> 4           <NA>                     0             <NA>        <NA>
#> 5           <NA>                     0             <NA>        <NA>
#> 6           <NA>                     0             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                  5.00             <NA>        <NA>
#> 2           <NA>                  5.00             <NA>        <NA>
#> 3           <NA>                 55.09             <NA>        <NA>
#> 4           <NA>                 69.00             <NA>        <NA>
#> 5           <NA>                 73.09             <NA>        <NA>
#> 6           <NA>                 49.00             <NA>        <NA>
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
#> 1                    840.3800                     844.3800
#> 2                    844.0000                     849.0000
#> 3                    872.3357                     875.3357
#> 4                    940.0000                     945.0000
#> 5                    905.8618                     908.8618
#> 6                    898.0009                     901.0009
#>   raise5minactualavailability raiseregactualavailability
#> 1                    845.3800                   455.3800
#> 2                    849.0000                   453.0000
#> 3                    874.3357                   458.4201
#> 4                    945.0000                   640.6532
#> 5                    907.8618                   665.8609
#> 6                    902.0009                   469.8198
#>   lower6secactualavailability lower60secactualavailability
#> 1                         597                          618
#> 2                         441                          462
#> 3                         813                          854
#> 4                         599                          620
#> 5                         869                          910
#> 6                         671                          672
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         628                  1386.0575       <NA>       <NA>
#> 2                         472                   997.4375       <NA>       <NA>
#> 3                         864                  1782.1718       <NA>       <NA>
#> 4                         630                  1225.7843       <NA>       <NA>
#> 5                         920                  1858.4176       <NA>       <NA>
#> 6                         682                  1864.1793       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                      49.345               6177.015 455.80598
#> 2                      70.980               6241.280 405.53831
#> 3                      66.975               6179.405 410.77021
#> 4                      65.995               6157.865 429.51997
#> 5                      65.770               6143.450 408.28279
#> 6                      63.890               6207.360 397.75276
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               455.8060                         0     120.45362    335.35236
#> 2               405.5383                         0      92.65983    312.87848
#> 3               410.7702                         0      77.12774    333.64247
#> 4               429.5200                         0      71.47012    358.04985
#> 5               408.2828                         0      61.30191    346.98088
#> 6               397.7528                         0      55.29207    342.46069
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1          120.45362          335.3524                     0
#> 2           92.65983          312.8785                     0
#> 3           77.12774          333.6425                     0
#> 4           71.47012          358.0498                     0
#> 5           61.30191          346.9809                     0
#> 6           55.29207          342.4607                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                  50.97                      0                    353.0000
#> 2                  53.58                      0                    353.0000
#> 3                  56.00                      0                    401.3357
#> 4                  61.00                      0                    464.0000
#> 5                  63.00                      0                    448.8618
#> 6                  69.00                      0                    421.0009
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         464             120.45362             335.3524
#> 2                         358              92.65983             312.8785
#> 3                         590              77.12774             333.6425
#> 4                         466              71.47012             358.0498
#> 5                         646              61.30191             346.9809
#> 6                         628              55.29207             342.4607
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        3421.262580          1933          1950        919.619960
#> 2        3366.808240          1932          1950        857.275470
#> 3        3312.364720          1932          1950       1043.578950
#> 4        3254.660620          1933          1951          720.3468
#> 5        3203.348660          1938          1952        714.138220
#> 6        3123.782660          1937          1954        960.179320
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  3                3491.797640   6088.09
#> 2                  3                3445.748230   6128.20
#> 3                  3                3396.696050   6067.80
#> 4                  3                3332.797270   6048.45
#> 5                  8                3266.501760   6030.60
#> 6                  3                3201.561790   6096.00
options(op)
# }
```
