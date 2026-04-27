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
#> Warning: Cache integrity check failed for 663db9a3edd3d6c2.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 83734a79445255be.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 2952f1c3f5618caa.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for e99c7150f177de03.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8cc03171fd348de8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 27ec6ef0de574d06.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for a348477d62462e04.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 8453898c0a89422e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for e32ba6f18f31464f.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 21dd0f409f3b043b.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for ff25b76850c904b8.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 58571bf4da845962.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 076374883ffa513e.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> Warning: Cache integrity check failed for 4be4691aa7671288.zip; re-downloading.
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> # aemo_tbl: AEMO demand VIC1 (operational)
#> # Source:   http://nemweb.com.au
#> # Licence:  AEMO Copyright Permissions Notice
#> # Retrieved: 2026-04-27 20:52 UTC 
#> # Rows: 6  Cols: 127
#> 
#>        settlementdate runno regionid dispatchinterval intervention totaldemand
#> 1 2026-04-28 05:55:00     1     VIC1      20260428023            0     4763.22
#> 2 2026-04-28 06:00:00     1     VIC1      20260428024            0     4835.03
#> 3 2026-04-28 06:05:00     1     VIC1      20260428025            0     4880.92
#> 4 2026-04-28 06:10:00     1     VIC1      20260428026            0     4998.72
#> 5 2026-04-28 06:15:00     1     VIC1      20260428027            0     5086.37
#> 6 2026-04-28 06:20:00     1     VIC1      20260428028            0     5147.78
#>   availablegeneration availableload demandforecast dispatchablegeneration
#> 1            9063.863          1294             47                5482.46
#> 2            9076.237          1294             47                5519.63
#> 3            9085.835          1294             46                5482.45
#> 4            9087.603          1294             49                5554.00
#> 5            9096.859          1294             53                5578.50
#> 6            9093.141          1294             55                5646.64
#>   dispatchableload netinterchange excessgeneration lower5mindispatch
#> 1                0         719.24                0              <NA>
#> 2                0         684.60                0              <NA>
#> 3                0         601.53                0              <NA>
#> 4                0         555.28                0              <NA>
#> 5                0         492.14                0              <NA>
#> 6                0         498.86                0              <NA>
#>   lower5minimport lower5minlocaldispatch lower5minlocalprice lower5minlocalreq
#> 1            <NA>                      0                <NA>              <NA>
#> 2            <NA>                      0                <NA>              <NA>
#> 3            <NA>                     29                <NA>              <NA>
#> 4            <NA>                     25                <NA>              <NA>
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
#> 1              <NA>            <NA>                 180.00                <NA>
#> 2              <NA>            <NA>                 176.00                <NA>
#> 3              <NA>            <NA>                 211.00                <NA>
#> 4              <NA>            <NA>                 121.00                <NA>
#> 5              <NA>            <NA>                 132.00                <NA>
#> 6              <NA>            <NA>                 129.65                <NA>
#>   raise5minlocalreq raise5minprice raise5minreq raise5minsupplyprice
#> 1              <NA>           <NA>         <NA>                 <NA>
#> 2              <NA>           <NA>         <NA>                 <NA>
#> 3              <NA>           <NA>         <NA>                 <NA>
#> 4              <NA>           <NA>         <NA>                 <NA>
#> 5              <NA>           <NA>         <NA>                 <NA>
#> 6              <NA>           <NA>         <NA>                 <NA>
#>   raise60secdispatch raise60secimport raise60seclocaldispatch
#> 1               <NA>             <NA>                  281.00
#> 2               <NA>             <NA>                  256.95
#> 3               <NA>             <NA>                  277.00
#> 4               <NA>             <NA>                  253.01
#> 5               <NA>             <NA>                  288.00
#> 6               <NA>             <NA>                  318.00
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
#> 1                 279.82                <NA>              <NA>           <NA>
#> 2                 166.61                <NA>              <NA>           <NA>
#> 3                 197.68                <NA>              <NA>           <NA>
#> 4                 178.34                <NA>              <NA>           <NA>
#> 5                 258.00                <NA>              <NA>           <NA>
#> 6                 315.47                <NA>              <NA>           <NA>
#>   raise6secreq raise6secsupplyprice aggegatedispatcherror
#> 1         <NA>                 <NA>                  <NA>
#> 2         <NA>                 <NA>                  <NA>
#> 3         <NA>                 <NA>                  <NA>
#> 4         <NA>                 <NA>                  <NA>
#> 5         <NA>                 <NA>                  <NA>
#> 6         <NA>                 <NA>                  <NA>
#>   aggregatedispatcherror         lastchanged initialsupply clearedsupply
#> 1               -3.61709 2026/04/28 05:50:03    4750.92712       4791.61
#> 2               -6.62280 2026/04/28 05:55:03    4822.23369       4859.65
#> 3               -8.09435 2026/04/28 06:00:03    4870.06689        4901.8
#> 4               -3.73189 2026/04/28 06:05:04    4980.26754       5015.81
#> 5                0.00000 2026/04/28 06:10:04    5053.46316       5099.36
#> 6              -12.83514 2026/04/28 06:15:04    5123.25461       5161.77
#>   lowerregimport lowerreglocaldispatch lowerreglocalreq lowerregreq
#> 1           <NA>                    75             <NA>        <NA>
#> 2           <NA>                     0             <NA>        <NA>
#> 3           <NA>                     5             <NA>        <NA>
#> 4           <NA>                    70             <NA>        <NA>
#> 5           <NA>                    50             <NA>        <NA>
#> 6           <NA>                    42             <NA>        <NA>
#>   raiseregimport raisereglocaldispatch raisereglocalreq raiseregreq
#> 1           <NA>                126.00             <NA>        <NA>
#> 2           <NA>                133.70             <NA>        <NA>
#> 3           <NA>                143.00             <NA>        <NA>
#> 4           <NA>                125.00             <NA>        <NA>
#> 5           <NA>                118.33             <NA>        <NA>
#> 6           <NA>                 98.00             <NA>        <NA>
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
#> 1                    1057.000                     1062.000
#> 2                    1043.302                     1046.302
#> 3                    1085.000                     1109.000
#> 4                    1044.000                     1049.000
#> 5                    1056.773                     1062.325
#> 6                    1006.000                     1011.000
#>   raise5minactualavailability raiseregactualavailability
#> 1                    1044.000                   787.1827
#> 2                    1030.302                   803.2046
#> 3                    1091.000                   854.0000
#> 4                    1032.000                   807.0000
#> 5                    1043.325                   800.6582
#> 6                     992.000                   623.5329
#>   lower6secactualavailability lower60secactualavailability
#> 1                         793                          794
#> 2                         795                          796
#> 3                         796                          797
#> 4                         785                          786
#> 5                         785                          786
#> 6                         685                          686
#>   lower5minactualavailability lowerregactualavailability lorsurplus lrcsurplus
#> 1                         804                   944.9982       <NA>       <NA>
#> 2                         806                   944.9982       <NA>       <NA>
#> 3                         807                   897.9982       <NA>       <NA>
#> 4                         796                   944.9982       <NA>       <NA>
#> 5                         796                   944.9982       <NA>       <NA>
#> 6                         696                   964.9982       <NA>       <NA>
#>   totalintermittentgeneration demand_and_nonschedgen      uigf
#> 1                    51.26233               4842.872 505.86288
#> 2                    53.43973               4913.090 525.23724
#> 3                    53.30649               4955.106 538.83523
#> 4                    55.09764               5070.908  545.6025
#> 5                    57.50374               5156.864 566.85915
#> 6                    60.42247               5222.192 573.14137
#>   semischedule_clearedmw semischedule_compliancemw ss_solar_uigf ss_wind_uigf
#> 1               505.8629                         0             0    505.86288
#> 2               525.2372                         0             0    525.23724
#> 3               538.8352                         0             0    538.83523
#> 4               545.6025                         0             0     545.6025
#> 5               566.8591                         0             0    566.85915
#> 6               573.1414                         0             0    573.14137
#>   ss_solar_clearedmw ss_wind_clearedmw ss_solar_compliancemw
#> 1                  0          505.8629                     0
#> 2                  0          525.2372                     0
#> 3                  0          538.8352                     0
#> 4                  0          545.6025                     0
#> 5                  0          566.8591                     0
#> 6                  0          573.1414                     0
#>   ss_wind_compliancemw wdr_initialmw wdr_available wdr_dispatched
#> 1                    0             0             0              0
#> 2                    0             0             0              0
#> 3                    0             0             0              0
#> 4                    0             0             0              0
#> 5                    0             0             0              0
#> 6                    0             0             0              0
#>   raise1seclocaldispatch lower1seclocaldispatch raise1secactualavailability
#> 1                    217                      0                    596.9999
#> 2                    213                      0                    583.3018
#> 3                    218                      0                    585.0000
#> 4                    214                      0                    584.0000
#> 5                    214                      0                    596.6673
#> 6                    206                      0                    551.0000
#>   lower1secactualavailability ss_solar_availability ss_wind_availability
#> 1                         608                     0             505.8629
#> 2                         610                     0             525.2372
#> 3                         611                     0             538.8352
#> 4                         600                     0             545.6025
#> 5                         600                     0             566.8591
#> 6                         600                     0             573.1414
#>   bdu_energy_storage bdu_min_avail bdu_max_avail bdu_clearedmw_gen
#> 1         470.511930          1294          1084                23
#> 2         467.328980          1294          1077         35.795430
#> 3           465.7845          1294          1073          0.110760
#> 4           459.5497          1294          1068                 0
#> 5         454.706420          1294          1056                 0
#> 6         448.981320          1294          1046                60
#>   bdu_clearedmw_load bdu_initial_energy_storage demand_mw
#> 1                  0                 473.180970   4763.22
#> 2                  0                 471.025790   4835.03
#> 3                  0                 468.267910   4880.92
#> 4                  0                 463.457050   4998.72
#> 5                  0                 456.466080   5086.37
#> 6                  0                 453.716460   5147.78
options(op)
# }
```
