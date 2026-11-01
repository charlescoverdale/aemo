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
#> # Retrieved: 2026-11-01 14:06 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-11-01 23:10:00     1     VIC1      20261101230            0     4869.27
#> 2 2026-11-01 23:15:00     1     VIC1      20261101231            0     4940.29
#> 3 2026-11-01 23:20:00     1     VIC1      20261101232            0     4915.24
#> 4 2026-11-01 23:25:00     1     VIC1      20261101233            0     4998.36
#> 5 2026-11-01 23:30:00     1     VIC1      20261101234            0     4909.14
#> 6 2026-11-01 23:35:00     1     VIC1      20261101235            0     4953.73
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            8767.404          2162             57                4718.40
#> 2            8795.222          2162             49                4724.63
#> 3            8806.844          2162             25                4862.43
#> 4            8573.238          2162              9                4680.52
#> 5            8598.219          2162              8                4710.81
#> 6            8584.437          2162             -7                4668.59
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1               51        -201.87                0              <NA>
#> 2               51        -266.66                0              <NA>
#> 3               50        -102.80                0              <NA>
#> 4               50        -367.84                0              <NA>
#> 5               50        -248.32                0              <NA>
#> 6               50        -335.14                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                  69.00                <NA>              <NA>
#> 2            <NA>                  69.00                <NA>              <NA>
#> 3            <NA>                  74.00                <NA>              <NA>
#> 4            <NA>                 100.42                <NA>              <NA>
#> 5            <NA>                  74.00                <NA>              <NA>
#> 6            <NA>                 116.07                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                   188.0                 <NA>
#> 2             <NA>                   176.1                 <NA>
#> 3             <NA>                   192.0                 <NA>
#> 4             <NA>                   176.0                 <NA>
#> 5             <NA>                   193.0                 <NA>
#> 6             <NA>                   170.0                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                 178.17                <NA>
#> 2              <NA>            <NA>                  67.00                <NA>
#> 3              <NA>            <NA>                 176.78                <NA>
#> 4              <NA>            <NA>                  62.00                <NA>
#> 5              <NA>            <NA>                 161.82                <NA>
#> 6              <NA>            <NA>                  60.00                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                  256.0                <NA>
#> 2              <NA>            <NA>                  147.9                <NA>
#> 3              <NA>            <NA>                  245.0                <NA>
#> 4              <NA>            <NA>                  134.0                <NA>
#> 5              <NA>            <NA>                  129.0                <NA>
#> 6              <NA>            <NA>                  180.0                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     130
#> 2               <NA>             <NA>                     130
#> 3               <NA>             <NA>                     130
#> 4               <NA>             <NA>                     130
#> 5               <NA>             <NA>                     128
#> 6               <NA>             <NA>                     227
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
#> 1                     99                <NA>              <NA>           <NA>
#> 2                    105                <NA>              <NA>           <NA>
#> 3                    105                <NA>              <NA>           <NA>
#> 4                     99                <NA>              <NA>           <NA>
#> 5                     97                <NA>              <NA>           <NA>
#> 6                    161                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1                5.27159 2026/11/01 23:05:03    4912.81656       4970.12
#> 2                5.52326 2026/11/01 23:10:03    4986.46256       5036.92
#> 3                6.30604 2026/11/01 23:15:04    4994.43221       5025.67
#> 4                6.00935 2026/11/01 23:20:04    5086.39119       5095.34
#> 5                4.00945 2026/11/01 23:25:04    5021.09511       5013.39
#> 6                0.00000 2026/11/01 23:30:04    5058.77398        5053.3
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    40             <NA>        <NA>
#> 2           <NA>                    40             <NA>        <NA>
#> 3           <NA>                    25             <NA>        <NA>
#> 4           <NA>                    35             <NA>        <NA>
#> 5           <NA>                    25             <NA>        <NA>
#> 6           <NA>                     5             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                     5             <NA>        <NA>
#> 2           <NA>                     5             <NA>        <NA>
#> 3           <NA>                     5             <NA>        <NA>
#> 4           <NA>                   111             <NA>        <NA>
#> 5           <NA>                    62             <NA>        <NA>
#> 6           <NA>                     7             <NA>        <NA>
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
#> 1                        1121                         1123
#> 2                        1121                         1124
#> 3                        1086                         1089
#> 4                        1073                         1078
#> 5                        1099                         1102
#> 6                        1122                         1133
#>   raise5minactualavailability raiseregactualavailability
#> 1                        1123                   941.0000
#> 2                        1123                  1018.1003
#> 3                        1091                   778.4099
#> 4                        1077                   982.5662
#> 5                        1102                   993.8580
#> 6                        1132                  1055.9991
#>   lower6secactualavailability lower60secactualavailability
#> 1                         827                          868
#> 2                         777                          798
#> 3                         877                          918
#> 4                         727                          748
#> 5                         877                          918
#> 6                         677                          678
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         878                   1259.906       <NA>       <NA>
#> 2                         808                   1255.492       <NA>       <NA>
#> 3                         928                   1518.652       <NA>       <NA>
#> 4                         758                   1224.438       <NA>       <NA>
#> 5                         928                   1401.749       <NA>       <NA>
#> 6                         688                   1199.000       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                      16.325               4986.445  358.4038
#> 2                      17.820               5054.740 347.22247
#> 3                      19.140               5044.810 336.84366
#> 4                      18.800               5114.140 329.23754
#> 5                      19.355               5032.745 333.21881
#> 6                      20.125               5073.425  320.4368
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               358.4038                         0             0     358.4038
#> 2               347.2225                         0             0    347.22247
#> 3               336.8437                         0             0    336.84366
#> 4               329.2375                         0             0    329.23754
#> 5               333.2188                         0             0    333.21881
#> 6               320.4368                         0             0     320.4368
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          358.4038                     0
#> 2                  0          347.2225                     0
#> 3                  0          336.8437                     0
#> 4                  0          329.2375                     0
#> 5                  0          333.2188                     0
#> 6                  0          320.4368                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                 149.57                  31.41                         631
#> 2                  90.00                  31.74                         632
#> 3                 105.50                  35.23                         598
#> 4                 164.43                  35.14                         590
#> 5                 135.14                  35.76                         611
#> 6                 126.00                  36.78                         632
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         657                     0             358.4038
#> 2                         647                     0             347.2225
#> 3                         657                     0             336.8437
#> 4                         647                     0             329.2375
#> 5                         657                     0             333.2188
#> 6                         637                     0             320.4368
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        1961.110030          2162          1833               148
#> 2        1971.651710          2162          1872               191
#> 3        1973.820510          2162          1894        355.590050
#> 4        1974.256390          2162          1917               189
#> 5          1983.4475          2162          1938               236
#> 6        1985.542510          2162          1938               220
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                 51                1971.763290   4869.27
#> 2                 51                1983.280660   4940.29
#> 3                 50                1994.091350   4915.24
#> 4                 50                1997.389150   4998.36
#> 5                 50                1998.715230   4909.14
#> 6                 50                2004.669950   4953.73
options(op)
# }
```
