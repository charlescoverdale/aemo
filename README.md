# aemo

[![R-CMD-check](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/charlescoverdale/aemo/actions/workflows/R-CMD-check.yaml) [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

An R package for accessing public market data from the [Australian Energy Market Operator](https://aemo.com.au). Wholesale electricity prices, regional demand, dispatch, interconnector flows, rooftop PV, generator bids, predispatch forecasts, FCAS markets, and gas markets across the National Electricity Market.

## What is AEMO?

The Australian Energy Market Operator is the independent system operator and market operator for the **National Electricity Market (NEM)**, which serves the eastern and southern states of Australia, and the **reformed Wholesale Electricity Market (WEM)** in Western Australia (SCED and essential system services markets, go-live 1 October 2023). AEMO also operates the Victorian Declared Transmission System and the Short Term Trading Market for gas (Adelaide, Brisbane, Sydney hubs), the Wallumbilla Gas Supply Hub, and the East Coast Gas System functions. The Australian Energy Regulator (**AER**) is the economic regulator; the Australian Energy Market Commission (**AEMC**) is the rule maker.

The NEM is one of the longest interconnected transmission systems in the world and generates around 200 TWh of electricity a year (2024 calendar year was 217 TWh including rooftop PV) across five regions (Queensland, New South Wales plus the ACT, Victoria, South Australia, and Tasmania). Annual NEM wholesale turnover typically falls in the **AUD 15 to 25 billion range**, with 2023-24 at AUD 18.6 billion (AER Wholesale Electricity Market Performance Report, December 2024), plus tens to a few hundred million in frequency control ancillary services (FCAS) depending on volatility. Since **1 October 2021** the NEM has run on a 5-minute dispatch *and* settlement cycle (previously 5-minute dispatch with 30-minute settlement); every five minutes AEMO publishes prices, demand, generator output, interconnector flows, bids, and forecasts.

All of this is free and public. AEMO publishes the raw dispatch files to **NEMweb** (<http://nemweb.com.au>) within minutes of each dispatch interval, and retains historical archives in the **Market Management System Data Model (MMSDM)** going back to the start of the NEM in December 1998. Flagship planning publications (the **Integrated System Plan (ISP)**, Electricity Statement of Opportunities, and Gas Statement of Opportunities) are released on aemo.com.au.

## Why does this package exist?

NEMweb is generous but unfriendly. There are over 100 report folders. Files are zipped CSVs with a proprietary row-dispatch format (`C,` comments, `I,` column headers, `D,` data rows, `F,` footers) that many R-native CSV readers can't parse. A single dispatch file might contain four different tables (prices, demand, interconnector flows, unit output) all interleaved in one CSV. Monthly archives for some tables are multi-gigabyte. Schema versions change between MMSDM releases (the v4-to-v5 transition in **April 2021**, coincident with the 5-minute settlement program, added columns to `DISPATCHLOAD`). AEMO is decommissioning the NEMweb HTTP endpoint on **7 April 2026** and migrating the base URL on **30 April 2026**.

```r
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

NEMweb directory listings are parsed into tidy data frames. The `C,/I,/D,/F,` row-dispatch format is handled per-file so schema drift is transparent. Base URL is configurable via `options(aemo.base_url = ...)` to handle the April 2026 migration. Rate-limiting and caching are in-box.

## Package history and name reclaim

The `aemo` package name was previously held by Imanuel Costigan's package, which was on CRAN from June 2014 to April 2020 (v0.1.0 to v0.3.0) and archived on 29 December 2021. That package implemented three functions covering prices and demand only. This rewrite is an independent implementation that shares only the package name and expands scope to the full NEMweb and MMSDM data surface.

Because the old registry entry still exists, the standard CRAN status and download badges pull from Costigan's historical data (CRAN 0.3.0, ~5 downloads per month, 40K lifetime) rather than from this rewrite. Those three badges are omitted above until v0.1.0 of the new package lands on CRAN and the registry snaps to it.

## How does aemo compare to NEMOSIS and nemwebR?

The authoritative tool for NEM data analysis is UNSW-CEEM's [**NEMOSIS**](https://github.com/UNSW-CEEM/NEMOSIS), written in Python. It is well-maintained, feature-rich, and used across the Australian energy research community. If you're already in Python, use it.

In R, [nemwebR](https://github.com/aleemon/nemwebR) is a single-author GitHub-only utility with no release. This package (`aemo`) fills the equivalent niche on CRAN.

| Package | Language | Status | Coverage |
|---|---|---|---|
| **NEMOSIS** | Python (CEEM) | Active, released on PyPI | Most MMSDM dynamic and static tables, plus forecast tables |
| **NEMSEER** | Python (CEEM) | Active | Forecast tables (P5MIN, PREDISPATCH, PASA) |
| **nempy** | Python (CEEM) | Active | NEM dispatch simulator, not a data wrapper |
| [nemwebR](https://github.com/aleemon/nemwebR) | R | GitHub, no release | Prices, dispatch, bids, DUDETAILSUMMARY |
| **aemo** (this package) | R | CRAN | Current NEMweb + reference data plus size-guarded bids |

## Installation

```r
install.packages("aemo")

# Or install the development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/aemo")
```

## Quick start

```r
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

All timestamps are AEST (UTC+10, fixed year-round) matching AEMO's market clock (NER clause 2.2.6). Using `"Australia/Sydney"` would silently shift every summer interval by one hour. The `tzone` attribute on every `settlementdate` column is `"Australia/Brisbane"`.

Timestamps are **period-ending**: a row stamped `14:05:00` covers the 5-minute interval ending at 14:05.

```r
attr(p$settlementdate, "tzone")  # "Australia/Brisbane"
```

### Intervention runs

`DISPATCHPRICE` contains two run types in every file: the **market pricing run** (`INTERVENTION = 0`, used in settlement) and the **physical/intervention run** (`INTERVENTION = 1`, issued during market directions or suspension). All functions default to `intervention = FALSE`, returning market pricing rows only.

During the June 2022 NEM suspension AEMO issued directions across all regions for several days. Querying that period with the default settings returns only the market pricing run, not the direction-influenced run:

```r
# Default: market pricing run only (correct for settlement analysis)
p_market <- aemo_price("NSW1", "2022-06-13", "2022-06-14")

# Both runs (use for direction-cost analysis)
p_both <- aemo_price("NSW1", "2022-06-13", "2022-06-14",
                     intervention = TRUE)
table(p_both$intervention)  # "0": market run rows, "1": intervention rows
```

### Worked example: price spike forensics

```r
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

| Function | Description | Interval |
|---|---|---|
| `aemo_price()` | Regional wholesale price (DISPATCHPRICE or TRADINGPRICE). Pre-5MS (before 1 Oct 2021) uses TRADINGIS; post-5MS aggregates six 5-min prices per trading interval. | 5-min or 30-min |
| `aemo_fcas()` | FCAS prices across ten services (eight contingency plus two regulation, including R1/L1 Very Fast from 9 October 2023) | 5-min |
| `aemo_price_caps()` | Market Price Cap, Floor, CPT, and APC by financial year (FY 2015-16 onwards). Static reference table. | Annual |

### Demand and generation

| Function | Description | Interval |
|---|---|---|
| `aemo_demand()` | Regional demand: operational, operational-less-SNSG, or native (includes estimated rooftop PV) | 5-min |
| `aemo_dispatch_units()` | Per-DUID generator output (SCADA actual or dispatch target MW) | 5-min |
| `aemo_rooftop_pv()` | Region-level rooftop PV actual or forecast | 30-min |

### Dispatch and constraints

| Function | Description | Interval |
|---|---|---|
| `aemo_constraints()` | Binding transmission and system constraints with shadow prices (marginal values). Use this to answer "why was the RRP AUD 15,000?" | 5-min |
| `aemo_fcas_enablement()` | FCAS enablement volumes (MW) per DUID across ten services (from DISPATCHLOAD). Quantity side of the FCAS market. | 5-min |
| `aemo_interconnector()` | MW flow, losses, and limits on the seven NEM interconnectors | 5-min |
| `aemo_bids()` | Generator bid stack: daily (BIDDAYOFFER_D) or per-interval (BIDPEROFFER_D, with size guard) | Day or 5-min |

### Forecasts

| Function | Description | Interval |
|---|---|---|
| `aemo_predispatch()` | Price and demand forecasts: 5-minute-ahead (P5MIN, 12 intervals) or 40-hour-ahead predispatch (30-min resolution) | 5-min or 30-min |
| `aemo_pasa()` | Projected Assessment of System Adequacy: short-term (1-7 day) or medium-term (2-year) | Hourly or daily |

### Reference data

| Function | Description |
|---|---|
| `aemo_units()` | DUID registry downloaded from MMSDM DUDETAILSUMMARY (500+ DUIDs with region, schedule type, fuel class). Fallback to a 12-row sample if MMSDM is unreachable. |
| `aemo_mlf()` | Marginal Loss Factors by DUID and financial year, from MMSDM MARGINALLOSSFACTOR. Used in PPA revenue reconstruction and settlement. |
| `aemo_dlf()` | Distribution Loss Factors by connection point and financial year, from MMSDM LOSSFACTORMODEL. |
| `aemo_regions()` | NEM region metadata (5 regions, static) |
| `aemo_interconnectors()` | NEM interconnector topology and energisation dates (7 links, static) |

### Low-level access and configuration

| Function | Description |
|---|---|
| `aemo_nemweb_ls()` | List files in any NEMweb directory |
| `aemo_nemweb_download()` | Raw zipped-CSV download from NEMweb |
| `aemo_cache_info()`, `aemo_clear_cache()` | Cache management |
| `aemo_throttle()` | Request-rate configuration |

### Gas

| Function | Description | Interval |
|---|---|---|
| `aemo_gas()` | STTM (Adelaide, Brisbane, Sydney) and DWGM (Victoria) gas markets | Daily |

## Size guards

AEMO's bid tables are large. `BIDPEROFFER_D` (per-interval bid price and volume bands) has monthly archives on the order of 0.5 to 1.5 GB zipped (much larger uncompressed). A naive full-year pull is several gigabytes of compressed data and tens of millions of rows.

`aemo_bids()` enforces a 30-day span guard by default and refuses longer spans without explicit consent:

```r
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

```r
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

```r
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

```r
# Query each region once
nsw <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
vic <- aemo_price("VIC1", "2024-06-01", "2024-06-01 01:00:00")

# Average price
mean(as.numeric(nsw$rrp), na.rm = TRUE)
mean(as.numeric(vic$rrp), na.rm = TRUE)
```

### Reference tables

```r
# No network needed
aemo_regions()
aemo_interconnectors()

# Small generator registry (fallback shipped in package)
aemo_units()
```

### Explore NEMweb directly

```r
# List files in a NEMweb report directory
f <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
head(f)

# Download a specific file
path <- aemo_nemweb_download(f$url[nrow(f)])
path
```

## Data source and licence

Data is published by AEMO at <http://nemweb.com.au> under the **AEMO Copyright Permissions Notice** (not CC BY 4.0; the notice is similar but carries AEMO-specific attribution language). See <https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions> for the full terms. This package caches downloads to `tools::R_user_dir("aemo", "cache")`.

Attribution on derivative work (AEMO's requirement in full): *Source: AEMO. AEMO makes no representation as to the accuracy or completeness of this data.*

## Known limitations

- **No reformed WEM.** The Wholesale Electricity Market in Western Australia runs on SCED and essential system services markets via WEMDE (go-live 1 October 2023), a separate data model from the NEM's MMSDM. WEM coverage is planned for a future release.
- **No 4-second FCAS.** The sub-second FCAS files (`FCAS_4_SECOND`) are hundreds of MB per day and niche. Planned for a future release.
- **No settlement tables.** `SETCFM` and `SETRESIDUALS` (settlement reconciliation) are not yet wrapped. Gentailer reconciliation workflows need these. Use `aemo_nemweb_download()` with an MMSDM URL directly.
- **No ISP, GSOO, or IASR forecast workbooks.** AEMO's long-run planning studies are published as XLSX supplements. Use AEMO's publications page directly.
- **No Wallumbilla GSH or ECGS gas data.** Out of scope for v0.1.0.
- **Known upstream gap.** AEMO has a documented gap in `BIDPEROFFER_D` between March 2021 and July 2024 that is not yet backfilled. Expect missing observations across that span.
- **NEMweb HTTP decommissioning 7 April 2026 and base-URL migration 30 April 2026.** The package uses `options(aemo.base_url = ...)` so you can point at a new host without reinstalling.
- **Schema drift.** `DISPATCHLOAD` added columns in April 2021 (MMSDM v5.0, coincident with 5-minute settlement). The `I,` header row in each file is the source of truth, so the parser handles this transparently, but inspect `names(df)` before any cross-MMSDM-version join.

## Related packages

**Python equivalent:** UNSW-CEEM's [NEMOSIS](https://github.com/UNSW-CEEM/NEMOSIS) is the established Python library for NEM data. Use it if you're in Python.

**R ecosystem:**

| Package | Description |
|---|---|
| [`cer`](https://github.com/charlescoverdale/cer) | Australian Clean Energy Regulator (ACCUs, Safeguard, NGER, LRET, SRES) |
| [`carbondata`](https://github.com/charlescoverdale/carbondata) | Global carbon markets (EU ETS, UK ETS, RGGI, California, Verra, Gold Standard) |
| [`climatekit`](https://github.com/charlescoverdale/climatekit) | 35 climate indices (temperature, precipitation, drought) |
| [`readnoaa`](https://github.com/charlescoverdale/readnoaa) | NOAA climate and weather data |
| [`readaec`](https://github.com/charlescoverdale/readaec) | Australian Electoral Commission |
| [`readabs`](https://github.com/mattcowgill/readabs) | Australian Bureau of Statistics |
| [`readrba`](https://github.com/mattcowgill/readrba) | Reserve Bank of Australia |

## Citation

```r
citation("aemo")
```
