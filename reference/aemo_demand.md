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
#> Warning: Cache integrity check failed for d15d470c4a6a9a24.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for a8a882bfffda28c7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 64a5dec40bed14bf.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c2d69e7fd374a18f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 09ceddd4b8e23f70.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 6080e733a9d5e2ee.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4519db0ecbcd63ed.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 53aeb92b6406fab8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 521c3ebd63a722f9.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3b3c0151c599da35.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 55237c7ddeaa8ce7.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 3567538254aae775.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 7ff46adf86691433.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-09-19 10:26 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-09-19 19:30:00     1     VIC1      20260919186            0     5168.76
#> 2 2026-09-19 19:35:00     1     VIC1      20260919187            0     5153.47
#> 3 2026-09-19 19:40:00     1     VIC1      20260919188            0     5131.22
#> 4 2026-09-19 19:45:00     1     VIC1      20260919189            0     5085.94
#> 5 2026-09-19 19:50:00     1     VIC1      20260919190            0     5088.45
#> 6 2026-09-19 19:55:00     1     VIC1      20260919191            0     5038.73
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            8766.135          1565            -19                4784.73
#> 2            8649.856          1565            -20                4567.72
#> 3            8590.270          1564            -19                4609.27
#> 4            8628.130          1565            -17                4687.13
#> 5            8498.000          1565            -18                4512.00
#> 6            8447.439          1565            -17                4426.44
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                0        -384.03                0              <NA>
#> 2                0        -585.76                0              <NA>
#> 3                0        -521.95                0              <NA>
#> 4                0        -398.81                0              <NA>
#> 5                0        -576.45                0              <NA>
#> 6                0        -612.29                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                 182.00                <NA>              <NA>
#> 2            <NA>                 122.27                <NA>              <NA>
#> 3            <NA>                 177.00                <NA>              <NA>
#> 4            <NA>                 120.75                <NA>              <NA>
#> 5            <NA>                  63.00                <NA>              <NA>
#> 6            <NA>                  74.00                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                  180.32                 <NA>
#> 2             <NA>                  163.64                 <NA>
#> 3             <NA>                  184.00                 <NA>
#> 4             <NA>                  190.00                 <NA>
#> 5             <NA>                   80.00                 <NA>
#> 6             <NA>                  196.00                 <NA>
#>   lower60seclocalreq lower60secprice lower60secreq lower60secsupplyprice
#> 1               <NA>            <NA>          <NA>                  <NA>
#> 2               <NA>            <NA>          <NA>                  <NA>
#> 3               <NA>            <NA>          <NA>                  <NA>
#> 4               <NA>            <NA>          <NA>                  <NA>
#> 5               <NA>            <NA>          <NA>                  <NA>
#> 6               <NA>            <NA>          <NA>                  <NA>
#>   lower6secdispatch lower6secimport lower6seclocaldispatch lower6seclocalprice
#> 1              <NA>            <NA>                 183.55                <NA>
#> 2              <NA>            <NA>                 101.88                <NA>
#> 3              <NA>            <NA>                 182.00                <NA>
#> 4              <NA>            <NA>                 187.00                <NA>
#> 5              <NA>            <NA>                  70.00                <NA>
#> 6              <NA>            <NA>                  72.00                <NA>
#>   lower6seclocalreq lower6secprice lower6secreq lower6secsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise5mindispatch raise5minimport raise5minlocaldispatch raise5minlocalprice
#> 1              <NA>            <NA>                 155.72                <NA>
#> 2              <NA>            <NA>                 177.00                <NA>
#> 3              <NA>            <NA>                 159.00                <NA>
#> 4              <NA>            <NA>                 207.00                <NA>
#> 5              <NA>            <NA>                 179.00                <NA>
#> 6              <NA>            <NA>                 135.00                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                     177
#> 2               <NA>             <NA>                     177
#> 3               <NA>             <NA>                     172
#> 4               <NA>             <NA>                     180
#> 5               <NA>             <NA>                     145
#> 6               <NA>             <NA>                     179
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
#> 1                    149                <NA>              <NA>           <NA>
#> 2                    152                <NA>              <NA>           <NA>
#> 3                    144                <NA>              <NA>           <NA>
#> 4                    180                <NA>              <NA>           <NA>
#> 5                    129                <NA>              <NA>           <NA>
#> 6                    155                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1                9.42146 2026/09/19 19:25:02    5182.15042       5172.42
#> 2                6.69095 2026/09/19 19:30:03    5174.54019       5163.36
#> 3                0.00000 2026/09/19 19:35:03    5159.66146       5141.56
#> 4                1.21108 2026/09/19 19:40:03    5114.96932       5097.29
#> 5                1.43537 2026/09/19 19:45:03    5117.68121       5098.36
#> 6                0.38887 2026/09/19 19:50:04    5067.52439       5050.86
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    36             <NA>        <NA>
#> 2           <NA>                    20             <NA>        <NA>
#> 3           <NA>                     0             <NA>        <NA>
#> 4           <NA>                     0             <NA>        <NA>
#> 5           <NA>                     0             <NA>        <NA>
#> 6           <NA>                     0             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                     3             <NA>        <NA>
#> 2           <NA>                     4             <NA>        <NA>
#> 3           <NA>                     9             <NA>        <NA>
#> 4           <NA>                     2             <NA>        <NA>
#> 5           <NA>                    36             <NA>        <NA>
#> 6           <NA>                    32             <NA>        <NA>
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
#> 1                    956.4053                     959.4053
#> 2                    988.1392                     992.1392
#> 3                    886.0000                     890.0000
#> 4                    910.0009                     915.0009
#> 5                    926.0000                     929.0000
#> 6                   1040.0009                    1044.0009
#>   raise5minactualavailability raiseregactualavailability
#> 1                    958.4053                   442.0000
#> 2                    991.1392                   547.1392
#> 3                    885.0000                   447.0000
#> 4                    905.0009                   375.0000
#> 5                    921.0000                   471.0000
#> 6                   1016.0009                   480.0000
#>   lower6secactualavailability lower60secactualavailability
#> 1                         881                          902
#> 2                         931                          972
#> 3                         831                          852
#> 4                         881                          902
#> 5                         659                          700
#> 6                         823                          864
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         902                   2112.344       <NA>       <NA>
#> 2                         972                   2089.501       <NA>       <NA>
#> 3                         852                   2082.593       <NA>       <NA>
#> 4                         902                   2154.593       <NA>       <NA>
#> 5                         700                   1438.281       <NA>       <NA>
#> 6                         864                   1692.436       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    178.1592               5350.579 882.13515
#> 2                    173.8414               5337.201 863.85631
#> 3                    172.2604               5313.820 895.27018
#> 4                    171.0847               5268.375 926.13047
#> 5                    174.8299               5273.190 953.99954
#> 6                    179.0726               5229.933 965.43941
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               882.1351                         0             0    882.13515
#> 2               863.8563                         0             0    863.85631
#> 3               895.2702                         0             0    895.27018
#> 4               926.1305                         0             0    926.13047
#> 5               953.9995                         0             0    953.99954
#> 6               965.4394                         0             0    965.43941
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          882.1351                     0
#> 2                  0          863.8563                     0
#> 3                  0          895.2702                     0
#> 4                  0          926.1305                     0
#> 5                  0          953.9995                     0
#> 6                  0          965.4394                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                    109                   0.00                    498.4053
#> 2                    118                   0.00                    512.1392
#> 3                    120                  34.09                    397.0000
#> 4                    108                  31.36                    435.0009
#> 5                    108                  30.95                    451.0000
#> 6                    107                   0.00                    550.0009
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         756                     0             882.1351
#> 2                         766                     0             863.8563
#> 3                         756                     0             895.2702
#> 4                         756                     0             926.1305
#> 5                         544                     0             953.9995
#> 6                         658                     0             965.4394
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        1358.536950          1565          1584        998.594730
#> 2        1280.864510          1565          1486        799.860760
#> 3        1205.237030          1564          1392               810
#> 4        1135.986650          1565          1399        856.999080
#> 5        1070.056620          1565          1231               644
#> 6        1018.754760          1565          1169        546.999080
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  0                1451.435850   5168.76
#> 2                  0                1359.690030   5153.47
#> 3                  0                1276.716710   5131.22
#> 4                  0                  1209.1777   5085.94
#> 5                  0                1136.809260   5088.45
#> 6                  0                1070.253670   5038.73
options(op)
# }
```
