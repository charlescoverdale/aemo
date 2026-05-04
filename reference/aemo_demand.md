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
#> Warning: Cache integrity check failed for eaa634678b4a2bca.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cd4602a6994b6b4c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b2aec91284871c0d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for db5b6b9d469c0eec.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cf18331ac9e83316.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 10e7a8bf983f8e7a.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 01e404ee368f3949.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for dc6440f93bd0db25.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b58ffdd7fa90190c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b7a88a2bef031b86.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 530a154e96f563e0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 45c9e0ddb0d9ab0e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for fd4f0969136fdcd0.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 62f05652aabc843d.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-04 19:18 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-05-05 04:20:00     1     VIC1      20260505004            0     4081.62
#> 2 2026-05-05 04:25:00     1     VIC1      20260505005            0     4097.81
#> 3 2026-05-05 04:30:00     1     VIC1      20260505006            0     4169.09
#> 4 2026-05-05 04:35:00     1     VIC1      20260505007            0     4208.45
#> 5 2026-05-05 04:40:00     1     VIC1      20260505008            0     4205.10
#> 6 2026-05-05 04:45:00     1     VIC1      20260505009            0     4147.63
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            10289.17           888              5                5721.30
#> 2            10284.47           889              5                5676.16
#> 3            10267.36           819              8                5705.27
#> 4            10326.70           601             14                5659.07
#> 5            10273.78           561             16                5639.40
#> 6            10254.05           551             19                5563.78
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1              256        1383.68                0              <NA>
#> 2              234        1344.35                0              <NA>
#> 3              191        1345.17                0              <NA>
#> 4               38        1412.62                0              <NA>
#> 5               40        1394.30                0              <NA>
#> 6               51        1365.15                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                     29                <NA>              <NA>
#> 2            <NA>                     27                <NA>              <NA>
#> 3            <NA>                     27                <NA>              <NA>
#> 4            <NA>                     27                <NA>              <NA>
#> 5            <NA>                     37                <NA>              <NA>
#> 6            <NA>                     29                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                  123.10                 <NA>
#> 2             <NA>                  121.00                 <NA>
#> 3             <NA>                  100.00                 <NA>
#> 4             <NA>                   71.00                 <NA>
#> 5             <NA>                  117.31                 <NA>
#> 6             <NA>                   85.00                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                     60                <NA>
#> 2              <NA>            <NA>                     49                <NA>
#> 3              <NA>            <NA>                     46                <NA>
#> 4              <NA>            <NA>                     58                <NA>
#> 5              <NA>            <NA>                     61                <NA>
#> 6              <NA>            <NA>                     39                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 218.68                <NA>
#> 2              <NA>            <NA>                 226.38                <NA>
#> 3              <NA>            <NA>                 203.00                <NA>
#> 4              <NA>            <NA>                 227.00                <NA>
#> 5              <NA>            <NA>                 207.00                <NA>
#> 6              <NA>            <NA>                 251.47                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  268.07
#> 2               <NA>             <NA>                  305.00
#> 3               <NA>             <NA>                  284.27
#> 4               <NA>             <NA>                  293.00
#> 5               <NA>             <NA>                  301.00
#> 6               <NA>             <NA>                  289.80
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
#> 1                 227.07                <NA>              <NA>           <NA>
#> 2                 226.74                <NA>              <NA>           <NA>
#> 3                 193.00                <NA>              <NA>           <NA>
#> 4                 156.00                <NA>              <NA>           <NA>
#> 5                 156.00                <NA>              <NA>           <NA>
#> 6                 198.00                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               -1.00343 2026/05/05 04:15:07    4451.70387        4428.3
#> 2                0.86747 2026/05/05 04:20:10    4443.53593       4418.53
#> 3               -0.54328 2026/05/05 04:25:07    4475.15187       4446.52
#> 4               -1.36932 2026/05/05 04:30:08    4476.87082       4338.04
#> 5               -4.42203 2026/05/05 04:35:01    4321.43402       4335.41
#> 6                0.00000 2026/05/05 04:40:03    4274.26246       4273.39
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                105.00             <NA>        <NA>
#> 2           <NA>                114.00             <NA>        <NA>
#> 3           <NA>                114.00             <NA>        <NA>
#> 4           <NA>                 54.00             <NA>        <NA>
#> 5           <NA>                 86.00             <NA>        <NA>
#> 6           <NA>                 52.73             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    70             <NA>        <NA>
#> 2           <NA>                    70             <NA>        <NA>
#> 3           <NA>                    68             <NA>        <NA>
#> 4           <NA>                    67             <NA>        <NA>
#> 5           <NA>                    46             <NA>        <NA>
#> 6           <NA>                    20             <NA>        <NA>
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
#> 1                    1193.866                     1207.866
#> 2                    1308.646                     1314.312
#> 3                    1293.093                     1306.093
#> 4                    1213.000                     1231.719
#> 5                    1328.919                     1342.378
#> 6                    1294.000                     1346.000
#>   raise5minactualavailability raiseregactualavailability
#> 1                    1206.866                  1125.8657
#> 2                    1316.312                  1334.3124
#> 3                    1305.093                  1016.0935
#> 4                    1229.719                   986.0000
#> 5                    1340.378                   984.7217
#> 6                    1345.000                  1052.0625
#>   lower6secactualavailability lower60secactualavailability
#> 1                    473.0000                     513.0000
#> 2                    515.0000                     555.0000
#> 3                    502.5000                     542.5000
#> 4                    492.0000                     532.0000
#> 5                    605.3907                     645.3907
#> 6                    582.0000                     622.0000
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                    491.0000                   526.8438       <NA>       <NA>
#> 2                    543.0000                   556.8438       <NA>       <NA>
#> 3                    524.5000                   602.4194       <NA>       <NA>
#> 4                    516.0000                   555.4466       <NA>       <NA>
#> 5                    625.3907                   661.0751       <NA>       <NA>
#> 6                    607.0000                   649.4199       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen       uigf
#> 1                    201.2337               4629.534 2306.16765
#> 2                    193.4155               4611.946 2301.47451
#> 3                    183.3270               4629.847 2284.36168
#> 4                    174.5965               4512.637 2344.69937
#> 5                    177.6175               4513.028  2291.7808
#> 6                    179.5482               4452.938 2272.04799
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               2306.168                         0             0   2306.16765
#> 2               2301.475                         0             0   2301.47451
#> 3               2284.362                         0             0   2284.36168
#> 4               2344.699                         0             0   2344.69937
#> 5               2291.781                         0             0    2291.7808
#> 6               2272.048                         0             0   2272.04799
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          2306.168                     0
#> 2                  0          2301.475                     0
#> 3                  0          2284.362                     0
#> 4                  0          2344.699                     0
#> 5                  0          2291.781                     0
#> 6                  0          2272.048                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                    238                  36.00                    657.0000
#> 2                    244                   5.00                    765.0000
#> 3                    273                  25.58                    789.0467
#> 4                    236                  24.43                    656.0000
#> 5                    238                  34.00                    764.0000
#> 6                    276                   4.00                    698.0000
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                       298.0                     0             2306.168
#> 2                       340.0                     0             2301.475
#> 3                       372.5                     0             2284.362
#> 4                       412.0                     0             2344.699
#> 5                       439.0                     0             2291.781
#> 6                       438.0                     0             2272.048
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        3165.584170           888          1555                40
#> 2        3182.280320           889          1555                 0
#> 3        3198.075540           819          1555                 3
#> 4        3204.163920           601          1555                13
#> 5        3206.538670           561          1555                 0
#> 6        3208.428680           551          1555                 0
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                256                3145.773930   4081.62
#> 2                234                  3164.8786   4097.81
#> 3                191                3182.446230   4169.09
#> 4                 38                3196.672220   4208.45
#> 5                 40                3204.593670   4205.10
#> 6                 51                3204.857820   4147.63
options(op)
# }
```
