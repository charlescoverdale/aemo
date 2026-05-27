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
#> Warning: Cache integrity check failed for b37b24fab532740c.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 1a6737d7ee51f10b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c211adad13e70857.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b37bc086adfa726f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ee397b3245f43f0e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for c080bcd163adfab3.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for b479124e6cd4c0e2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 71903318aadadcfd.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 714b678e30a7e178.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 58979a1ae0f33869.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 59ebe07a338af2fd.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for cb9d73ec163aceae.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 97eab698f7aaf817.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-05-27 07:57 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-05-27 17:00:00     1     VIC1      20260527156            0     6648.45
#> 2 2026-05-27 17:05:00     1     VIC1      20260527157            0     6687.84
#> 3 2026-05-27 17:10:00     1     VIC1      20260527158            0     6719.87
#> 4 2026-05-27 17:15:00     1     VIC1      20260527159            0     6733.76
#> 5 2026-05-27 17:20:00     1     VIC1      20260527160            0     6858.12
#> 6 2026-05-27 17:25:00     1     VIC1      20260527161            0     6852.04
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            8902.758           205             50                7069.63
#> 2            9026.618           221             53                6875.66
#> 3            9036.439           350             54                6832.26
#> 4            9040.174           631             51                6752.17
#> 5            9049.314           775             48                6819.09
#> 6            9040.196           786             47                6853.70
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                0         421.18                0              <NA>
#> 2                0         187.83                0              <NA>
#> 3                0         112.39                0              <NA>
#> 4                0          18.41                0              <NA>
#> 5                0         -39.03                0              <NA>
#> 6                0           1.66                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                      0                <NA>              <NA>
#> 2            <NA>                     10                <NA>              <NA>
#> 3            <NA>                     20                <NA>              <NA>
#> 4            <NA>                      0                <NA>              <NA>
#> 5            <NA>                     62                <NA>              <NA>
#> 6            <NA>                     62                <NA>              <NA>
#>   lower5minprice lower5minreq lower5minsupplyprice lower60secdispatch
#> 1           <NA>         <NA>                 <NA>               <NA>
#> 2           <NA>         <NA>                 <NA>               <NA>
#> 3           <NA>         <NA>                 <NA>               <NA>
#> 4           <NA>         <NA>                 <NA>               <NA>
#> 5           <NA>         <NA>                 <NA>               <NA>
#> 6           <NA>         <NA>                 <NA>               <NA>
#>   lower60secimport lower60seclocaldispatch lower60seclocalprice
#> 1             <NA>                    0.00                 <NA>
#> 2             <NA>                    0.00                 <NA>
#> 3             <NA>                    0.00                 <NA>
#> 4             <NA>                    0.00                 <NA>
#> 5             <NA>                   14.57                 <NA>
#> 6             <NA>                   52.71                 <NA>
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
#> 1              <NA>            <NA>                    221                <NA>
#> 2              <NA>            <NA>                    171                <NA>
#> 3              <NA>            <NA>                    108                <NA>
#> 4              <NA>            <NA>                    118                <NA>
#> 5              <NA>            <NA>                    159                <NA>
#> 6              <NA>            <NA>                    108                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  216.00
#> 2               <NA>             <NA>                  168.00
#> 3               <NA>             <NA>                  142.55
#> 4               <NA>             <NA>                  180.00
#> 5               <NA>             <NA>                  134.00
#> 6               <NA>             <NA>                  118.55
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
#> 1                 192.44                <NA>              <NA>           <NA>
#> 2                 202.00                <NA>              <NA>           <NA>
#> 3                 199.86                <NA>              <NA>           <NA>
#> 4                 215.11                <NA>              <NA>           <NA>
#> 5                 197.70                <NA>              <NA>           <NA>
#> 6                 156.55                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               -1.80874 2026/05/27 16:55:03    6633.18556       6676.52
#> 2                0.00000 2026/05/27 17:00:03    6662.71555       6705.12
#> 3               -2.27319 2026/05/27 17:05:03    6687.22398       6732.71
#> 4               -2.81118 2026/05/27 17:10:04    6703.21336       6740.69
#> 5                0.00000 2026/05/27 17:15:04    6818.93366       6868.94
#> 6                0.00000 2026/05/27 17:20:04    6820.50132       6863.08
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    11             <NA>        <NA>
#> 2           <NA>                    12             <NA>        <NA>
#> 3           <NA>                    11             <NA>        <NA>
#> 4           <NA>                    15             <NA>        <NA>
#> 5           <NA>                    24             <NA>        <NA>
#> 6           <NA>                    11             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                    54             <NA>        <NA>
#> 2           <NA>                    35             <NA>        <NA>
#> 3           <NA>                    33             <NA>        <NA>
#> 4           <NA>                    22             <NA>        <NA>
#> 5           <NA>                    61             <NA>        <NA>
#> 6           <NA>                    62             <NA>        <NA>
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
#> 1                         939                          955
#> 2                         838                          842
#> 3                         850                          855
#> 4                         890                          894
#> 5                         910                          922
#> 6                         786                          791
#>   raise5minactualavailability raiseregactualavailability
#> 1                         953                   507.5643
#> 2                         843                   265.0000
#> 3                         855                   286.1430
#> 4                         897                   320.8923
#> 5                         922                   417.3031
#> 6                         791                   338.9420
#>   lower6secactualavailability lower60secactualavailability
#> 1                       403.5                        422.5
#> 2                       423.5                        443.5
#> 3                       535.0                        554.0
#> 4                       433.0                        453.0
#> 5                       384.0                        383.0
#> 6                       421.0                        440.0
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                       418.5                   290.7500       <NA>       <NA>
#> 2                       438.5                   748.4375       <NA>       <NA>
#> 3                       549.0                   788.5938       <NA>       <NA>
#> 4                       451.0                   783.7500       <NA>       <NA>
#> 5                       380.0                   714.0000       <NA>       <NA>
#> 6                       437.0                   827.2568       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    45.16101               6721.681 364.95137
#> 2                    44.26789               6749.388 334.40696
#> 3                    46.56593               6779.276 344.56266
#> 4                    46.48146               6787.171 341.88585
#> 5                    49.79800               6918.738 352.20517
#> 6                    50.15549               6913.235 342.32074
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               362.7576                        40      37.20607     327.7453
#> 2               331.6184                        40      18.98563    315.42133
#> 3               341.4391                        40         8.908    335.65466
#> 4               337.1742                        40       4.34981    337.53604
#> 5               346.3139                        40       1.80045    350.40472
#> 6               337.1958                        40         0.292    342.02874
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1           37.20607          325.5516                     0
#> 2           18.51163          313.1068                     0
#> 3            7.53800          333.9011                     0
#> 4            4.34981          332.8244                     0
#> 5            1.80045          344.5134                     0
#> 6            0.29200          336.9038                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                   40             0             0              0
#> 2                   40             0             0              0
#> 3                   40             0             0              0
#> 4                   40             0             0              0
#> 5                   40             0             0              0
#> 6                   40             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                     99                      1                         454
#> 2                     64                      0                         353
#> 3                     61                      0                         363
#> 4                     63                      0                         405
#> 5                    105                      0                         424
#> 6                     61                      0                         300
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                       313.5              37.20607             325.5516
#> 2                       383.5              18.51163             313.1068
#> 3                       395.0               7.53800             333.9011
#> 4                       393.0               4.34981             332.8244
#> 5                       384.0               1.80045             344.5134
#> 6                       381.0               0.29200             336.9038
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1        1678.743490           205           929                56
#> 2        1663.652360           221           929               336
#> 3        1637.106990           350           929               299
#> 4        1616.389720           631           929               234
#> 5        1591.339310           775           929               253
#> 6        1571.882710           786           929        330.506790
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  0                1683.238520   6648.45
#> 2                  0                1681.368520   6687.84
#> 3                  0                1665.948520   6719.87
#> 4                  0                1640.718520   6733.76
#> 5                  0                1614.878490   6858.12
#> 6                  0                  1599.3885   6852.04
options(op)
# }
```
