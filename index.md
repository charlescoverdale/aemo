# aemo

[![CRAN
status](https://www.r-pkg.org/badges/version/aemo)](https://CRAN.R-project.org/package=aemo)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/aemo)](https://cran.r-project.org/package=aemo)
[![Total
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/aemo)](https://CRAN.R-project.org/package=aemo)
[![R-CMD-check](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

An R package for accessing public market data from the [Australian
Energy Market Operator](https://aemo.com.au). Wholesale electricity
prices, regional demand, dispatch, interconnector flows, rooftop PV,
generator bids, predispatch forecasts, FCAS markets, and gas markets
across the National Electricity Market.

## What is AEMO?

The Australian Energy Market Operator is the independent system operator
and market operator for the **National Electricity Market (NEM)**, which
serves the eastern and southern states of Australia, and the **reformed
Wholesale Electricity Market (WEM)** in Western Australia (SCED and
essential system services markets, go-live 1 October 2023). AEMO also
operates the Victorian Declared Transmission System and the Short Term
Trading Market for gas (Adelaide, Brisbane, Sydney hubs), the
Wallumbilla Gas Supply Hub, and the East Coast Gas System functions. The
Australian Energy Regulator (**AER**) is the economic regulator; the
Australian Energy Market Commission (**AEMC**) is the rule maker.

The NEM is one of the longest interconnected transmission systems in the
world and generates around 200 TWh of electricity a year (2024 calendar
year was 217 TWh including rooftop PV) across five regions (Queensland,
New South Wales plus the ACT, Victoria, South Australia, and Tasmania).
Annual NEM wholesale turnover typically falls in the **AUD 15 to 25
billion range**, with 2023-24 at AUD 18.6 billion (AER Wholesale
Electricity Market Performance Report, December 2024), plus tens to a
few hundred million in frequency control ancillary services (FCAS)
depending on volatility. Since **1 October 2021** the NEM has run on a
5-minute dispatch *and* settlement cycle (previously 5-minute dispatch
with 30-minute settlement); every five minutes AEMO publishes prices,
demand, generator output, interconnector flows, bids, and forecasts.

All of this is free and public. AEMO publishes the raw dispatch files to
**NEMweb** (<http://nemweb.com.au>) within minutes of each dispatch
interval, and retains historical archives in the **Market Management
System Data Model (MMSDM)** going back to the start of the NEM in
December 1998. Flagship planning publications (the **Integrated System
Plan (ISP)**, Electricity Statement of Opportunities, and Gas Statement
of Opportunities) are released on aemo.com.au.

## Why does this package exist?

NEMweb is generous but unfriendly. There are over 100 report folders.
Files are zipped CSVs with a proprietary row-dispatch format (`C,`
comments, `I,` column headers, `D,` data rows, `F,` footers) that many
R-native CSV readers can’t parse. A single dispatch file might contain
four different tables (prices, demand, interconnector flows, unit
output) all interleaved in one CSV. Monthly archives for some tables are
multi-gigabyte. Schema versions change between MMSDM releases (the
v4-to-v5 transition in **April 2021**, coincident with the 5-minute
settlement program, added columns to `DISPATCHLOAD`). AEMO is
decommissioning the NEMweb HTTP endpoint on **7 April 2026** and
migrating the base URL on **30 April 2026**.

``` r
# Without this package
listing <- rvest::read_html("http://nemweb.com.au/Reports/Current/DispatchIS_Reports/")
hrefs   <- rvest::html_attr(rvest::html_elements(listing, "a"), "href")
zip     <- paste0("http://nemweb.com.au/Reports/Current/DispatchIS_Reports/",
                  tail(grep("DISPATCHIS", hrefs, value = TRUE), 1))
path    <- tempfile(fileext = ".zip")
download.file(zip, path)
tmp     <- tempfile(); utils::unzip(path, exdir = tmp)
csv     <- list.files(tmp, pattern = "\\.CSV$", full.names = TRUE)[1]
# ... read the file line by line, split by "I,"/"D,"/"F," row type,
#     match I headers to D rows, build separate data frames per table,
#     validate that schema matches the MMSDM version, ...

# With this package
library(aemo)
aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
```

NEMweb directory listings are parsed into tidy data frames. The
`C,/I,/D,/F,` row-dispatch format is handled per-file so schema drift is
transparent. Base URL is configurable via `options(aemo.base_url = ...)`
to handle the April 2026 migration. Rate-limiting and caching are
in-box.

## Package history and name reclaim

The `aemo` package name was previously held by Imanuel Costigan’s
package, which was on CRAN from June 2014 to April 2020 (v0.1.0 to
v0.3.0) and archived on 29 December 2021. That package implemented three
functions covering prices and demand only. This rewrite is an
independent implementation that shares only the package name and expands
scope to the full NEMweb and MMSDM data surface.

Because the old registry entry still exists, the standard CRAN status
and download badges pull from Costigan’s historical data (CRAN 0.3.0, ~5
downloads per month, 40K lifetime) rather than from this rewrite. Those
three badges are omitted above until v0.4.0 of the new package lands on
CRAN and the registry snaps to it. The version starts at 0.4.0 so it
sits strictly above the last archived version (0.3.0), per CRAN policy
on reclaimed names.

## How does aemo compare to NEMOSIS and nemwebR?

The authoritative tool for NEM data analysis is UNSW-CEEM’s
[**NEMOSIS**](https://github.com/UNSW-CEEM/NEMOSIS), written in Python.
It is well-maintained, feature-rich, and used across the Australian
energy research community. If you’re already in Python, use it.

In R, [nemwebR](https://github.com/aleemon/nemwebR) is a single-author
GitHub-only utility with no release. This package (`aemo`) fills the
equivalent niche on CRAN.

| Package                                       | Language      | Status                   | Coverage                                                   |
|-----------------------------------------------|---------------|--------------------------|------------------------------------------------------------|
| **NEMOSIS**                                   | Python (CEEM) | Active, released on PyPI | Most MMSDM dynamic and static tables, plus forecast tables |
| **NEMSEER**                                   | Python (CEEM) | Active                   | Forecast tables (P5MIN, PREDISPATCH, PASA)                 |
| **nempy**                                     | Python (CEEM) | Active                   | NEM dispatch simulator, not a data wrapper                 |
| [nemwebR](https://github.com/aleemon/nemwebR) | R             | GitHub, no release       | Prices, dispatch, bids, DUDETAILSUMMARY                    |
| **aemo** (this package)                       | R             | CRAN                     | Current NEMweb + reference data plus size-guarded bids     |

## Installation

``` r
install.packages("aemo")

# Or install the development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/aemo")
```

## Quick start

``` r
library(aemo)

# Reference data (no network required)
aemo_regions()
aemo_interconnectors()
aemo_price_caps()       # MPC / MPF / CPT by financial year

# 5-minute wholesale prices for NSW, last hour
p <- aemo_price("NSW1", Sys.time() - 3600, Sys.time())
head(p)
# Key columns: settlementdate (POSIXct, AEST), regionid, rrp (AUD/MWh)

# Regional demand (operational)
d <- aemo_demand("VIC1", Sys.time() - 3600, Sys.time())

# FCAS prices across all 10 services
f <- aemo_fcas("NSW1", Sys.time() - 3600, Sys.time())

# Binding constraints with shadow prices (price-spike forensics)
c <- aemo_constraints(Sys.time() - 3600, Sys.time())
head(c[order(-c$marginalvalue), c("settlementdate", "constraintid",
                                   "marginalvalue", "rhs")])
```

### Timestamps: AEST not AEDT

All timestamps are AEST (UTC+10, fixed year-round) matching AEMO’s
market clock (NER clause 2.2.6). Using `"Australia/Sydney"` would
silently shift every summer interval by one hour. The `tzone` attribute
on every `settlementdate` column is `"Australia/Brisbane"`.

Timestamps are **period-ending**: a row stamped `14:05:00` covers the
5-minute interval ending at 14:05.

``` r
attr(p$settlementdate, "tzone")  # "Australia/Brisbane"
```

### Intervention runs

`DISPATCHPRICE` contains two run types in every file: the **market
pricing run** (`INTERVENTION = 0`, used in settlement) and the
**physical/intervention run** (`INTERVENTION = 1`, issued during market
directions or suspension). All functions default to
`intervention = FALSE`, returning market pricing rows only.

During the June 2022 NEM suspension AEMO issued directions across all
regions for several days. Querying that period with the default settings
returns only the market pricing run, not the direction-influenced run:

``` r
# Default: market pricing run only (correct for settlement analysis)
p_market <- aemo_price("NSW1", "2022-06-13", "2022-06-14")

# Both runs (use for direction-cost analysis)
p_both <- aemo_price("NSW1", "2022-06-13", "2022-06-14",
                     intervention = TRUE)
table(p_both$intervention)  # "0": market run rows, "1": intervention rows
```

### Worked example: price spike forensics

``` r
library(aemo)

# Step 1: find a high-price interval in SA
p <- aemo_price("SA1", "2024-03-01", "2024-03-02")
spike <- p[which.max(p$rrp), ]
spike[, c("settlementdate", "rrp")]

# Step 2: which constraint had the highest shadow price at that time?
c <- aemo_constraints(
  start = spike$settlementdate - 300,
  end   = spike$settlementdate
)
head(c[order(-c$marginalvalue), c("constraintid", "marginalvalue", "rhs")])

# Step 3: which generators were providing FCAS at that time?
e <- aemo_fcas_enablement(
  start = spike$settlementdate - 300,
  end   = spike$settlementdate
)
# Aggregate raise6secmw across DUIDs to see market-wide enablement
if ("raise6secmw" %in% names(e)) {
  aggregate(e$raise6secmw, by = list(e$settlementdate), FUN = sum, na.rm = TRUE)
}

# Step 4: what loss factor applies to a generator in SA?
mlf <- aemo_mlf(year = "2024-25")
head(mlf[mlf$regionid == "SA1", c("duid", "mlf")])
```

## Functions

### Prices

| Function                                                                                    | Description                                                                                                                                                      | Interval        |
|---------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| [`aemo_price()`](https://charlescoverdale.github.io/aemo/reference/aemo_price.md)           | Regional wholesale price (DISPATCHPRICE or TRADINGPRICE). Pre-5MS (before 1 Oct 2021) uses TRADINGIS; post-5MS aggregates six 5-min prices per trading interval. | 5-min or 30-min |
| [`aemo_fcas()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas.md)             | FCAS prices across ten services (eight contingency plus two regulation, including R1/L1 Very Fast from 9 October 2023)                                           | 5-min           |
| [`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md) | Market Price Cap, Floor, CPT, and APC by financial year (FY 2015-16 onwards). Static reference table.                                                            | Annual          |

### Demand and generation

| Function                                                                                            | Description                                                                                    | Interval |
|-----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|----------|
| [`aemo_demand()`](https://charlescoverdale.github.io/aemo/reference/aemo_demand.md)                 | Regional demand: operational, operational-less-SNSG, or native (includes estimated rooftop PV) | 5-min    |
| [`aemo_dispatch_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_dispatch_units.md) | Per-DUID generator output (SCADA actual or dispatch target MW)                                 | 5-min    |
| [`aemo_rooftop_pv()`](https://charlescoverdale.github.io/aemo/reference/aemo_rooftop_pv.md)         | Region-level rooftop PV actual or forecast                                                     | 30-min   |

### Dispatch and constraints

| Function                                                                                              | Description                                                                                                                        | Interval     |
|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|--------------|
| [`aemo_constraints()`](https://charlescoverdale.github.io/aemo/reference/aemo_constraints.md)         | Binding transmission and system constraints with shadow prices (marginal values). Use this to answer “why was the RRP AUD 15,000?” | 5-min        |
| [`aemo_fcas_enablement()`](https://charlescoverdale.github.io/aemo/reference/aemo_fcas_enablement.md) | FCAS enablement volumes (MW) per DUID across ten services (from DISPATCHLOAD). Quantity side of the FCAS market.                   | 5-min        |
| [`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md)   | MW flow, losses, and limits on the seven NEM interconnectors                                                                       | 5-min        |
| [`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md)                       | Generator bid stack: daily (BIDDAYOFFER_D) or per-interval (BIDPEROFFER_D, with size guard)                                        | Day or 5-min |

### Forecasts

| Function                                                                                      | Description                                                                                                       | Interval        |
|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|-----------------|
| [`aemo_predispatch()`](https://charlescoverdale.github.io/aemo/reference/aemo_predispatch.md) | Price and demand forecasts: 5-minute-ahead (P5MIN, 12 intervals) or 40-hour-ahead predispatch (30-min resolution) | 5-min or 30-min |
| [`aemo_pasa()`](https://charlescoverdale.github.io/aemo/reference/aemo_pasa.md)               | Projected Assessment of System Adequacy: short-term (1-7 day) or medium-term (2-year)                             | Hourly or daily |

### Reference data

| Function                                                                                              | Description                                                                                                                                                   |
|-------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)                     | DUID registry downloaded from MMSDM DUDETAILSUMMARY (500+ DUIDs with region, schedule type, fuel class). Fallback to a 12-row sample if MMSDM is unreachable. |
| [`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md)                         | Marginal Loss Factors by DUID and financial year, from MMSDM MARGINALLOSSFACTOR. Used in PPA revenue reconstruction and settlement.                           |
| [`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md)                         | Distribution Loss Factors by connection point and financial year, from MMSDM LOSSFACTORMODEL.                                                                 |
| [`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md)                 | NEM region metadata (5 regions, static)                                                                                                                       |
| [`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md) | NEM interconnector topology and energisation dates (7 links, static)                                                                                          |

### Low-level access and configuration

| Function                                                                                                                                                                                   | Description                         |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| [`aemo_nemweb_ls()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_ls.md)                                                                                                  | List files in any NEMweb directory  |
| [`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md)                                                                                      | Raw zipped-CSV download from NEMweb |
| [`aemo_cache_info()`](https://charlescoverdale.github.io/aemo/reference/aemo_cache_info.md), [`aemo_clear_cache()`](https://charlescoverdale.github.io/aemo/reference/aemo_clear_cache.md) | Cache management                    |
| [`aemo_throttle()`](https://charlescoverdale.github.io/aemo/reference/aemo_throttle.md)                                                                                                    | Request-rate configuration          |

### Gas

| Function                                                                      | Description                                                       | Interval |
|-------------------------------------------------------------------------------|-------------------------------------------------------------------|----------|
| [`aemo_gas()`](https://charlescoverdale.github.io/aemo/reference/aemo_gas.md) | STTM (Adelaide, Brisbane, Sydney) and DWGM (Victoria) gas markets | Daily    |

## Size guards

AEMO’s bid tables are large. `BIDPEROFFER_D` (per-interval bid price and
volume bands) has monthly archives on the order of 0.5 to 1.5 GB zipped
(much larger uncompressed). A naive full-year pull is several gigabytes
of compressed data and tens of millions of rows.

[`aemo_bids()`](https://charlescoverdale.github.io/aemo/reference/aemo_bids.md)
enforces a 30-day span guard by default and refuses longer spans without
explicit consent:

``` r
# Works (1-day span)
aemo_bids(duid = "BW01", start = "2024-06-01", end = "2024-06-02")

# Errors with a clear message
aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01")
# Error: Requested span is 152 days.
# Bids data is large (BIDPEROFFER_D monthly archives are multi-GB zipped).
# Pass allow_large = TRUE to proceed.

# Works with explicit opt-in
aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01",
          allow_large = TRUE)
```

## Examples

### Regional spot price by hour of day

``` r
library(aemo)

p <- aemo_price("NSW1",
                start = "2024-06-01",
                end = "2024-06-02")

p$hour <- as.integer(format(as.POSIXct(p$settlementdate), "%H"))
avg_by_hour <- aggregate(as.numeric(p$rrp) ~ p$hour, FUN = mean, na.rm = TRUE)
names(avg_by_hour) <- c("hour", "rrp")
plot(avg_by_hour, type = "l", xlab = "Hour", ylab = "AUD/MWh")
```

### Interconnector flows

``` r
# Heywood Interconnector (VIC-SA) flows for the past day
i <- aemo_interconnector(flow = "V-SA",
                          start = "2024-06-01",
                          end   = "2024-06-02")
head(i)

# Project EnergyConnect (V-S-N) Stage 1 went live in April 2025
pec <- aemo_interconnector(flow = "V-S-N",
                           start = "2025-06-01",
                           end   = "2025-06-02")
```

### Compare regions

``` r
# Query each region once
nsw <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
vic <- aemo_price("VIC1", "2024-06-01", "2024-06-01 01:00:00")

# Average price
mean(as.numeric(nsw$rrp), na.rm = TRUE)
mean(as.numeric(vic$rrp), na.rm = TRUE)
```

### Reference tables

``` r
# No network needed
aemo_regions()
aemo_interconnectors()

# Small generator registry (fallback shipped in package)
aemo_units()
```

### Explore NEMweb directly

``` r
# List files in a NEMweb report directory
f <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
head(f)

# Download a specific file
path <- aemo_nemweb_download(f$url[nrow(f)])
path
```

## Data source and licence

Data is published by AEMO at <http://nemweb.com.au> under the **AEMO
Copyright Permissions Notice** (not CC BY 4.0; the notice is similar but
carries AEMO-specific attribution language). See
<https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>
for the full terms. This package caches downloads to
`tools::R_user_dir("aemo", "cache")`.

Attribution on derivative work (AEMO’s requirement in full): *Source:
AEMO. AEMO makes no representation as to the accuracy or completeness of
this data.*

## Related packages

**Python equivalent:** UNSW-CEEM’s
[NEMOSIS](https://github.com/UNSW-CEEM/NEMOSIS) is the established
Python library for NEM data. Use it if you’re in Python.

**R ecosystem:**

| Package                                                        | Description                                                                    |
|----------------------------------------------------------------|--------------------------------------------------------------------------------|
| [`cer`](https://github.com/charlescoverdale/cer)               | Australian Clean Energy Regulator (ACCUs, Safeguard, NGER, LRET, SRES)         |
| [`carbondata`](https://github.com/charlescoverdale/carbondata) | Global carbon markets (EU ETS, UK ETS, RGGI, California, Verra, Gold Standard) |
| [`climatekit`](https://github.com/charlescoverdale/climatekit) | 35 climate indices (temperature, precipitation, drought)                       |
| [`readnoaa`](https://github.com/charlescoverdale/readnoaa)     | NOAA climate and weather data                                                  |
| [`readaec`](https://github.com/charlescoverdale/readaec)       | Australian Electoral Commission                                                |
| [`readabs`](https://github.com/mattcowgill/readabs)            | Australian Bureau of Statistics                                                |
| [`readrba`](https://github.com/mattcowgill/readrba)            | Reserve Bank of Australia                                                      |

## A note on GST

All NEM wholesale prices in AEMO’s published feeds, and hence in this
package, are **exclusive of GST**. See National Electricity Rules,
Chapter 10 (Definitions: “spot price”). When computing revenue figures
for comparison against published financial statements or retail prices,
gross up by 1.10 as appropriate.

## References

Methodology choices in this package follow the design conventions of the
established NEM literature. Where a design decision is non-obvious, the
docs cite the original:

- Gorman, N., Haghdadi, N., Bruce, A., & MacGill, I. (2018). *NEMOSIS:
  NEM Open Source Information Service: open-source access to Australian
  National Electricity Market Data*. Asia-Pacific Solar Research
  Conference. The authoritative reference for NEM data-model
  conventions.
- Gorman, N., Bruce, A., & MacGill, I. (2022). *Nempy: A Python package
  for modelling the Australian National Electricity Market dispatch
  procedure*. Journal of Open Source Software 7(70), 3596.
  [doi:10.21105/joss.03596](https://doi.org/10.21105/joss.03596).
- Prakash, A., Bruce, A., & MacGill, I. (2023). *NEMSEER: A Python
  package for downloading and handling historical National Electricity
  Market forecast data*. Journal of Open Source Software 8(92), 5883.
  [doi:10.21105/joss.05883](https://doi.org/10.21105/joss.05883). The
  `aemo_predispatch(run_datetime =)` vintage pattern follows NEMSEER.

Academic uses of NEM data this package is designed to support:

- Gonçalves, R. & Menezes, F. (2022). *The price impacts of the exit of
  the Hazelwood coal power plant*. Energy Economics 113, 106398.
  [doi:10.1016/j.eneco.2022.106398](https://doi.org/10.1016/j.eneco.2022.106398).
  Uses DISPATCHLOAD + BIDPEROFFER_D + DISPATCHPRICE at 5-min resolution.
- Mountain, B. (2025). *The exercise of market power in Australia’s
  National Electricity Market following the closure of the Hazelwood
  Power Station*. Victoria Energy Policy Centre working paper.
  [doi:10.2139/ssrn.5285882](https://doi.org/10.2139/ssrn.5285882).
- Nelson, T., Easton, L., Wand, M., Gilmore, J. & Nolan, T. (2024).
  *Electricity contract design and wholesale market outcomes in
  Australia’s National Electricity Market*. Australian Journal of
  Agricultural and Resource Economics 68(4), 784-804.
  [doi:10.1111/1467-8489.12588](https://doi.org/10.1111/1467-8489.12588).
- Rangarajan, S., Svec, J., Foley, S. & Trück, S. (2025). *Revisiting
  the crisis: An empirical analysis of the NEM suspension*. Energy
  Economics 141.
  [doi:10.1016/j.eneco.2024.107983](https://doi.org/10.1016/j.eneco.2024.107983).
  Uses MARKETNOTICEDATA + DISPATCHPRICE with `INTERVENTION = 1`.
- Simshauser, P. & Wild, P. (2024). *Rooftop Solar PV, Coal Plant
  Inflexibility and the Minimum Load Problem*. The Energy Journal.
  [doi:10.1177/01956574241283732](https://doi.org/10.1177/01956574241283732).
- Simshauser, P. & Gilmore, J. (2025). *Demand Shocks From the Gas
  Turbine Fleet in Australia’s National Electricity Market*. Australian
  Journal of Agricultural and Resource Economics.
  [doi:10.1111/1467-8489.70065](https://doi.org/10.1111/1467-8489.70065).
- Australian Energy Regulator (2025). *State of the Energy Market 2025,
  Chapter 2: National Electricity Market*.

## Citation

``` r
citation("aemo")
```

## Issues

Please report bugs or requests at
<https://github.com/charlescoverdale/aemo/issues>.

## Keywords

AEMO, Australian Energy Market Operator, NEM, National Electricity
Market, electricity prices, dispatch, demand, FCAS, MMSDM, NEMweb, gas
market, STTM, DWGM, Wallumbilla, AEMC, AER, energy data, electricity
market, R package, Australian energy data
