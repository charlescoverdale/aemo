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
#> # Retrieved: 2026-11-20 08:42 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-11-20 17:45:00     1     VIC1      20261120165            0     6071.42
#> 2 2026-11-20 17:50:00     1     VIC1      20261120166            0     6054.48
#> 3 2026-11-20 17:55:00     1     VIC1      20261120167            0     5961.59
#> 4 2026-11-20 18:00:00     1     VIC1      20261120168            0     6007.63
#> 5 2026-11-20 18:05:00     1     VIC1      20261120169            0     6038.40
#> 6 2026-11-20 18:10:00     1     VIC1      20261120170            0     6025.70
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            9400.239          2076             -1                5998.24
#> 2            9193.624          2077             -3                5830.69
#> 3            9124.922          2078              2                5753.92
#> 4            9053.715          2080              6                5740.71
#> 5            8937.337          2080              2                5661.34
#> 6            8887.027          2081              0                5625.03
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                3         -76.19                0              <NA>
#> 2                3        -226.78                0              <NA>
#> 3                3        -210.67                0              <NA>
#> 4                3        -269.91                0              <NA>
#> 5                3        -380.07                0              <NA>
#> 6                3        -403.67                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                  68.00                <NA>              <NA>
#> 2            <NA>                  68.74                <NA>              <NA>
#> 3            <NA>                 136.54                <NA>              <NA>
#> 4            <NA>                  65.00                <NA>              <NA>
#> 5            <NA>                  96.28                <NA>              <NA>
#> 6            <NA>                  55.00                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                     194                 <NA>
#> 2             <NA>                     188                 <NA>
#> 3             <NA>                     196                 <NA>
#> 4             <NA>                     195                 <NA>
#> 5             <NA>                     196                 <NA>
#> 6             <NA>                      72                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                 144.23                <NA>
#> 2              <NA>            <NA>                 138.82                <NA>
#> 3              <NA>            <NA>                 180.21                <NA>
#> 4              <NA>            <NA>                  69.00                <NA>
#> 5              <NA>            <NA>                 183.00                <NA>
#> 6              <NA>            <NA>                  59.00                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 129.00                <NA>
#> 2              <NA>            <NA>                 129.00                <NA>
#> 3              <NA>            <NA>                 129.00                <NA>
#> 4              <NA>            <NA>                 124.00                <NA>
#> 5              <NA>            <NA>                 135.00                <NA>
#> 6              <NA>            <NA>                 138.16                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     109
#> 2               <NA>             <NA>                     112
#> 3               <NA>             <NA>                     108
#> 4               <NA>             <NA>                     112
#> 5               <NA>             <NA>                     108
#> 6               <NA>             <NA>                     121
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
#> 1                     87                <NA>              <NA>           <NA>
#> 2                     90                <NA>              <NA>           <NA>
#> 3                     81                <NA>              <NA>           <NA>
#> 4                     81                <NA>              <NA>           <NA>
#> 5                     84                <NA>              <NA>           <NA>
#> 6                     99                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               24.50516 2026/11/20 17:40:03    6084.38073       6106.36
#> 2                6.71090 2026/11/20 17:45:03    6080.35531       6082.81
#> 3                5.99256 2026/11/20 17:50:03    5990.94217       5995.84
#> 4               16.76151 2026/11/20 17:55:03    6018.64184       6037.06
#> 5               26.66868 2026/11/20 18:00:04    6035.15463       6061.64
#> 6               34.96385 2026/11/20 18:05:04    6012.72119       6051.39
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                     0             <NA>        <NA>
#> 2           <NA>                     0             <NA>        <NA>
#> 3           <NA>                     0             <NA>        <NA>
#> 4           <NA>                     0             <NA>        <NA>
#> 5           <NA>                     0             <NA>        <NA>
#> 6           <NA>                     0             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                     0             <NA>        <NA>
#> 2           <NA>                     0             <NA>        <NA>
#> 3           <NA>                     0             <NA>        <NA>
#> 4           <NA>                     0             <NA>        <NA>
#> 5           <NA>                     0             <NA>        <NA>
#> 6           <NA>                     0             <NA>        <NA>
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
#> 1                    1011.001                     1016.001
#> 2                    1013.001                     1015.001
#> 3                    1011.001                     1015.001
#> 4                    1011.001                     1016.001
#> 5                    1011.001                     1016.001
#> 6                    1012.000                     1016.000
#>   raise5minactualavailability raiseregactualavailability
#> 1                    1016.001                   784.0000
#> 2                    1016.001                   759.1576
#> 3                    1017.001                   775.0000
#> 4                    1017.001                   743.0000
#> 5                    1016.001                   722.0000
#> 6                    1017.000                   694.0000
#>   lower6secactualavailability lower60secactualavailability
#> 1                         869                          910
#> 2                         819                          860
#> 3                         869                          910
#> 4                         869                          910
#> 5                         869                          910
#> 6                         655                          696
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         920                   1785.593       <NA>       <NA>
#> 2                         870                   1787.433       <NA>       <NA>
#> 3                         920                   1797.280       <NA>       <NA>
#> 4                         920                   1832.436       <NA>       <NA>
#> 5                         920                   1845.905       <NA>       <NA>
#> 6                         706                   1504.594       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    61.24495               6167.605 786.23851
#> 2                    65.55674               6148.367 579.62416
#> 3                   114.26888               6110.109 508.92207
#> 4                   116.93494               6153.995 436.71457
#> 5                   115.70002               6177.340 319.33694
#> 6                   106.33209               6157.722 267.02721
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               786.2385                         0     400.04213    386.19638
#> 2               579.6242                         0     270.51034    309.11382
#> 3               508.9221                         0     291.17175    217.75032
#> 4               436.7146                         0     262.63831    174.07626
#> 5               319.3369                         0     164.84378    154.49316
#> 6               267.0272                         0      118.6725    148.35471
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1           400.0421          386.1964                     0
#> 2           270.5103          309.1138                     0
#> 3           291.1717          217.7503                     0
#> 4           262.6383          174.0763                     0
#> 5           164.8438          154.4932                     0
#> 6           118.6725          148.3547                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                  64.99                      1                    519.0009
#> 2                  57.00                      1                    520.0009
#> 3                  57.00                      1                    519.0009
#> 4                  63.00                      1                    519.0009
#> 5                  65.00                      1                    519.0009
#> 6                  58.00                      1                    520.0000
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         654              400.0421             386.1964
#> 2                         654              270.5103             309.1138
#> 3                         654              291.1717             217.7503
#> 4                         654              262.6383             174.0763
#> 5                         654              164.8438             154.4932
#> 6                         540              118.6725             148.3547
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        3706.741950          2076          1971        361.999080
#> 2        3674.894360          2077          1972        401.069740
#> 3        3640.512590          2078          1974        394.999080
#> 4        3606.258220          2080          1975        455.999080
#> 5        3566.427220          2080          1976        486.999080
#> 6        3523.763090          2081          1978               503
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  3                3737.038590   6071.42
#> 2                  3                3707.284770   6054.48
#> 3                  3                3674.116550   5961.59
#> 4                  3                3642.056190   6007.63
#> 5                  3                3606.446980   6038.40
#> 6                  3                3566.573020   6025.70
options(op)
# }
```
