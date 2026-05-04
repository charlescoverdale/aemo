# Data dictionary: columns, tables, and AEMO source

This vignette maps each `aemo` package function to the underlying AEMO
table, lists the key columns returned, and defines the units and
conventions. Use it alongside the AEMO Market Management System Data
Model (MMSDM) Data Model documentation, which is the authoritative
source.

## Conventions

**Timezone.** All `settlementdate` and timestamp columns are `POSIXct`
in `"Australia/Brisbane"` (AEST, UTC+10, no daylight saving). See
[`vignette("timestamps")`](https://charlescoverdale.github.io/aemo/articles/timestamps.md)
for details.

**Period-ending.** A row stamped `14:05:00` covers the interval ending
at 14:05 (i.e. 14:00:01 to 14:05:00 inclusive).

**INTERVENTION.** All data functions default to `intervention = FALSE`,
returning only the market pricing run (`INTERVENTION = 0`). Pass
`intervention = TRUE` to include physical/intervention runs.

**Types.** All numeric columns are coerced from the raw character output
of the AEMO CSV files. Timestamps are POSIXct. ID columns (`regionid`,
`duid`, `constraintid`, etc.) remain character.

**GST.** All NEM wholesale prices in AEMO’s feeds, and therefore in
every `aemo_tbl`, are *exclusive of GST* (NER Chapter 10, definition of
“spot price”). When comparing revenue figures to published financial
statements or retail prices, gross up by 1.10 as appropriate.

------------------------------------------------------------------------

## `aemo_price()` : DISPATCHPRICE / TRADINGPRICE

**Source tables:** - 5-min: `DISPATCH_PRICE` from `DISPATCHIS_Reports` -
30-min pre-5MS: `TRADING_PRICE` from `TRADINGIS_Reports` - 30-min
post-5MS (from 1 Oct 2021): aggregated from `DISPATCH_PRICE`

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `regionid` | character | \- | NEM region (e.g. `"NSW1"`) |
| `rrp` | numeric | AUD/MWh | Regional Reference Price : the spot price used in settlement |
| `raise6secrrp` | numeric | AUD/MW | FCAS Raise 6-second service price (market run) |
| `lower6secrrp` | numeric | AUD/MW | FCAS Lower 6-second service price |
| `raise60secrrp` | numeric | AUD/MW | FCAS Raise 60-second service price |
| `lower60secrrp` | numeric | AUD/MW | FCAS Lower 60-second service price |
| `raise5minrrp` | numeric | AUD/MW | FCAS Raise 5-minute service price |
| `lower5minrrp` | numeric | AUD/MW | FCAS Lower 5-minute service price |
| `raiseregrrp` | numeric | AUD/MW | FCAS Regulation Raise price |
| `lowerregrrp` | numeric | AUD/MW | FCAS Regulation Lower price |
| `raise1secrrp` | numeric | AUD/MW | FCAS Very Fast Raise (from 9 Oct 2023) |
| `lower1secrrp` | numeric | AUD/MW | FCAS Very Fast Lower (from 9 Oct 2023) |
| `intervention` | character | 0/1 | 0 = market pricing run; 1 = physical/intervention run |

The `rrp` column may occasionally equal the Market Price Cap (MPC, ~AUD
17,500/MWh) or Market Price Floor (MPF, -AUD 1,000/MWh). See
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md)
for the exact values by financial year.

------------------------------------------------------------------------

## `aemo_demand()` : DISPATCHREGIONSUM

**Source table:** `DISPATCH_REGIONSUM` from `DISPATCHIS_Reports`

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `regionid` | character | \- | NEM region |
| `demand_mw` | numeric | MW | The requested demand measure (see below) |
| `totaldemand` | numeric | MW | Operational demand: grid-measured, met by scheduled/semi-scheduled gen |
| `ss_solar_uigf` | numeric | MW | Semi-scheduled solar UIGF (used for `operational_less_snsg`) |
| `ss_wind_uigf` | numeric | MW | Semi-scheduled wind UIGF |

**`measure` argument:** - `"operational"`: `TOTALDEMAND` : what AEMO
dispatches against - `"operational_less_snsg"`: `TOTALDEMAND` minus
semi-scheduled solar + wind UIGF - `"native"`: `TOTALDEMAND` plus
estimated rooftop PV : closest to actual end-use consumption

------------------------------------------------------------------------

## `aemo_dispatch_units()` : DISPATCH_UNIT_SCADA / DISPATCHLOAD

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `duid` | character | \- | Dispatchable Unit Identifier |
| `scadavalue` | numeric | MW | Actual SCADA output (when `measure = "scada_mw"`) |
| `totalmw` | numeric | MW | Dispatch target MW (when `measure = "target_mw"`, from DISPATCHLOAD) |

------------------------------------------------------------------------

## `aemo_constraints()` : DISPATCHCONSTRAINT

**Source table:** `DISPATCH_CONSTRAINT` from `DISPATCHIS_Reports`

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `constraintid` | character | \- | Generic constraint ID (e.g. `"N>>N-NIL_1"`) |
| `rhs` | numeric | MW or other | Right-hand side of the constraint (thermal limit, voltage limit, etc.) |
| `marginalvalue` | numeric | AUD/MWh | Shadow price on the constraint. Non-zero means the constraint is binding. The sum of marginalvalues across all binding constraints at a Regional Reference Node equals the network component of the regional price. |
| `violationdegree` | numeric | MW | How far the constraint was violated (should be zero in a normal dispatch) |
| `lhs` | numeric | MW or other | Left-hand side value (the actual flow or sum of flows) |

`min_marginal_value = 0.01` (default) suppresses rows where the shadow
price rounds to zero : these are near-binding constraints not actively
driving price.

------------------------------------------------------------------------

## `aemo_gencon()` : GENCONDATA

**Source table:** `GENCONDATA` from MMSDM archive

| Column | Type | Description |
|----|----|----|
| `genconid` | character | Constraint equation ID : matches `constraintid` in DISPATCHCONSTRAINT |
| `constrainttype` | character | `"LE"` (≤), `"GE"` (≥), or `"EQ"` (=) |
| `description` | character | Plain-language description of what the constraint models |
| `genericconstraintrhs` | numeric | Default RHS value (may be overridden in real-time by GENCONSETINVOKE) |
| `effectivedate` | POSIXct | Date from which this equation definition applies |

------------------------------------------------------------------------

## `aemo_fcas_enablement()` : DISPATCHLOAD

**Source table:** `DISPATCH_UNIT_SOLUTION` from `DISPATCHIS_Reports`

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `duid` | character | \- | DUID |
| `raise1secmw` | numeric | MW | Very Fast Raise enabled MW (from 9 Oct 2023) |
| `lower1secmw` | numeric | MW | Very Fast Lower enabled MW |
| `raise6secmw` | numeric | MW | Fast Raise enabled MW |
| `lower6secmw` | numeric | MW | Fast Lower enabled MW |
| `raise60secmw` | numeric | MW | Slow Raise enabled MW |
| `lower60secmw` | numeric | MW | Slow Lower enabled MW |
| `raise5minmw` | numeric | MW | Delayed Raise enabled MW |
| `lower5minmw` | numeric | MW | Delayed Lower enabled MW |
| `raiseregmw` | numeric | MW | Regulation Raise enabled MW |
| `lowerregmw` | numeric | MW | Regulation Lower enabled MW |

------------------------------------------------------------------------

## `aemo_interconnector()` : DISPATCHINTERCONNECTORRES

| Column | Type | Unit | Description |
|----|----|----|----|
| `settlementdate` | POSIXct | AEST | Period-ending timestamp |
| `interconnectorid` | character | \- | Interconnector ID (e.g. `"NSW1-QLD1"`, `"V-SA"`) |
| `mwflow` | numeric | MW | Actual MW flow (positive = export from `from_region`) |
| `mwlosses` | numeric | MW | MW losses on the interconnector |
| `exportlimit` | numeric | MW | Export limit in this interval |
| `importlimit` | numeric | MW | Import limit in this interval |

------------------------------------------------------------------------

## `aemo_mlf()` : MARGINALLOSSFACTOR

| Column | Type | Description |
|----|----|----|
| `financial_year` | character | NEM financial year, e.g. `"2024-25"` (1 July to 30 June) |
| `duid` | character | DUID |
| `connectionpointid` | character | Connection point ID |
| `regionid` | character | NEM region |
| `mlf` | numeric | Marginal Loss Factor. A value of 0.97 means the generator receives 97% of the regional RRP per MWh. Used in settlement: `payment = MWh × RRP × MLF × DLF`. |

------------------------------------------------------------------------

## `aemo_dlf()` : LOSSFACTORMODEL

| Column | Type | Description |
|----|----|----|
| `financial_year` | character | NEM financial year |
| `connectionpointid` | character | Connection point ID |
| `dlf` | numeric | Distribution Loss Factor. Combined with MLF to give total loss factor (TLF = MLF × DLF). |

------------------------------------------------------------------------

## `aemo_price_caps()` : static reference

| Column | Type | Description |
|----|----|----|
| `year` | character | Financial year, e.g. `"2024-25"` |
| `market_price_cap_aud_per_mwh` | numeric | Market Price Cap (MPC) : maximum spot price. Any RRP equal to this value is a cap event. |
| `market_price_floor_aud_per_mwh` | numeric | Market Price Floor (MPF) : minimum spot price (AUD -1,000/MWh since 2013). |
| `cumulative_price_threshold_aud` | numeric | Cumulative Price Threshold (CPT) : when rolling-7-day regional CPT is breached, the Administered Price Cap (APC) activates. |
| `administered_price_cap_aud_per_mwh` | numeric | Administered Price Cap (APC) : price ceiling during CPT-triggered suspension (AUD 300/MWh). |

------------------------------------------------------------------------

## `aemo_units()` : DUDETAILSUMMARY

| Column | Type | Description |
|----|----|----|
| `duid` | character | Dispatchable Unit Identifier : the primary key used in all dispatch tables |
| `stationid` | character | Station (power plant) ID : multiple DUIDs may share one station |
| `regionid` | character | NEM region |
| `dispatchtype` | character | `"GENERATOR"` or `"LOAD"` |
| `schedule_type` | character | `"SCHEDULED"`, `"SEMI-SCHEDULED"`, or `"NON-SCHEDULED"` |
| `connectionpointid` | character | Connection point : used to look up MLF/DLF |
| `start_date` | POSIXct | Registration start date |
| `end_date` | POSIXct | Registration end date (`NA` = currently active) |

------------------------------------------------------------------------

## `aemo_outages()` : NETWORK_OUTAGEDETAIL

| Column | Type | Description |
|----|----|----|
| `outageid` | character | Unique outage identifier |
| `starttime` | POSIXct | Outage start (AEST) |
| `endtime` | POSIXct | Outage end (AEST, `NA` if still open) |
| `substationid` | character | Substation ID |
| `equipmenttype` | character | Type of network element (e.g. `"LINE"`, `"TRANSFORMER"`) |
| `equipmentid` | character | Specific element ID |
| `outagetype` | character | `"PLANNED"` or `"FORCED"` |
| `regionid` | character | NEM region |
| `restarttimeunknown` | character | `"Y"` if the end time is uncertain |

------------------------------------------------------------------------

## `aemo_participants()` : PARTICIPANT + DUDETAILSUMMARY

| Column               | Type      | Description                                |
|----------------------|-----------|--------------------------------------------|
| `participantid`      | character | AEMO participant identifier (company code) |
| `participantclassid` | character | `"GENERATOR"`, `"LOAD"`, `"TRADER"`, etc.  |
| `name`               | character | Company name                               |
| `duid`               | character | DUID registered to this participant        |
| `stationid`          | character | Station ID                                 |
| `regionid`           | character | NEM region                                 |
| `dispatchtype`       | character | `"GENERATOR"` or `"LOAD"`                  |
| `schedule_type`      | character | Schedule classification                    |
