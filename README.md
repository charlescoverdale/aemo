# aemo

[![CRAN status](https://www.r-pkg.org/badges/version/aemo)](https://CRAN.R-project.org/package=aemo) [![CRAN downloads](https://cranlogs.r-pkg.org/badges/aemo)](https://cran.r-project.org/package=aemo) [![Total Downloads](https://cranlogs.r-pkg.org/badges/grand-total/aemo)](https://CRAN.R-project.org/package=aemo) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

An R package for accessing public market data from the [Australian Energy Market Operator](https://aemo.com.au). Wholesale electricity prices, regional demand, dispatch, interconnector flows, rooftop PV, generator bids, predispatch forecasts, FCAS markets, and gas markets across the National Electricity Market.

## What is AEMO?

The Australian Energy Market Operator is the independent system operator and market operator for the **National Electricity Market (NEM)**, which serves the eastern and southern states of Australia, and the **Wholesale Electricity Market (WEM)** in Western Australia. AEMO also operates the Victorian gas transmission network and the Short Term Trading Markets for gas in Adelaide, Brisbane, and Sydney.

The NEM is one of the longest interconnected transmission systems in the world and dispatches around 200 TWh of electricity a year across five regions (Queensland, New South Wales, Victoria, South Australia, and Tasmania). In a typical year the NEM settles AUD 20 billion or more in wholesale energy trades, plus several hundred million in frequency control ancillary services (FCAS). Dispatch runs on a 5-minute cycle: every five minutes AEMO publishes prices, demand, generator output, interconnector flows, bids, and forecasts.

All of this is free and public. AEMO publishes the raw dispatch files to **NEMweb** (<http://nemweb.com.au>) within minutes of each dispatch interval, and retains historical archives in the **Market Management System Data Model (MMSDM)** going back to the start of the NEM in 1998. If you want to know what the wholesale price was at 14:35 on a particular Tuesday in 2008, NEMweb has it.

## Why does this package exist?

NEMweb is generous but unfriendly. There are over 100 report folders. Files are zipped CSVs with a proprietary row-dispatch format (`C,` comments, `I,` column headers, `D,` data rows, `F,` footers) that many R-native CSV readers can't parse. A single dispatch file might contain four different tables (prices, demand, interconnector flows, unit output) all interleaved in one CSV. Monthly archives for some tables are multi-gigabyte. Schema versions change between MMSDM releases (the v4-to-v5 transition in October 2020 added columns to `DISPATCHLOAD`). And AEMO has flagged a NEMweb base URL migration for 30 April 2026.

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

## How does aemo compare to NEMOSIS and nemwebR?

The authoritative tool for NEM data analysis is UNSW-CEEM's [**NEMOSIS**](https://github.com/UNSW-CEEM/NEMOSIS), written in Python. It is well-maintained, feature-rich, and used across the Australian energy research community. If you're already in Python, use it.

In R, [nemwebR](https://github.com/aleemon/nemwebR) is a single-author GitHub-only utility with no release. This package (`aemo`) fills the equivalent niche on CRAN.

| Package | Language | Status | Coverage |
|---|---|---|---|
| **NEMOSIS** | Python (CEEM) | Active, released on PyPI | Full MMSDM historical tables plus forecasts |
| **NEMSEER** | Python (CEEM) | Active | Forecast tables (P5MIN, PREDISPATCH, PASA) |
| **nempy** | Python (CEEM) | Active | NEM dispatch simulator, not a data wrapper |
| [nemwebR](https://github.com/aleemon/nemwebR) | R | GitHub, no release | Prices, dispatch, bids, DUDETAILSUMMARY |
| **aemo** (this package) | R | CRAN | Current NEMweb + reference data plus size-guarded bids |

The archived `aemo` package (see [history](#history) below) covered 3 functions on prices and demand only. This rewrite is a fresh implementation.

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

# Reference data (no network)
aemo_regions()
aemo_interconnectors()

# 5-minute wholesale price for NSW
p <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
head(p)

# Regional demand
d <- aemo_demand("VIC1", "2024-06-01", "2024-06-01 01:00:00")

# Rooftop PV actual generation
r <- aemo_rooftop_pv("NSW1",
                     start = "2024-06-01",
                     end = "2024-06-01 12:00:00")
```

## Functions

| Function | Description | Interval |
|---|---|---|
| `aemo_price()` | Regional wholesale price (DISPATCHPRICE or TRADINGPRICE) | 5-min or 30-min |
| `aemo_demand()` | Regional demand (operational, operational less small non-scheduled, or native) | 5-min |
| `aemo_dispatch_units()` | Per-DUID generator output (SCADA or target MW) | 5-min |
| `aemo_interconnector()` | MW flow, losses, and limits on the six NEM interconnectors | 5-min |
| `aemo_rooftop_pv()` | Region-level rooftop PV actual or forecast | 30-min |
| `aemo_bids()` | Generator bid stack (daily or per-interval, with size guard) | Day or 5-min |
| `aemo_predispatch()` | Price and demand forecasts out to 5 minutes, 40 hours, or 7 days | 5-min to 40-hour |
| `aemo_pasa()` | Projected Assessment of System Adequacy (short 1-7 day or medium 2-year) | Hourly or daily |
| `aemo_fcas()` | Frequency control ancillary services prices across eight services | 5-min |
| `aemo_gas()` | STTM (Adelaide, Brisbane, Sydney) and DWGM (Victoria) gas markets | Daily |
| `aemo_units()` | DUID registry with fuel, capacity, region, station, owner | - |
| `aemo_regions()` | NEM region metadata (5 regions, static) | - |
| `aemo_interconnectors()` | NEM interconnector topology and limits (6 links, static) | - |
| `aemo_nemweb_ls()` | List files in any NEMweb directory | - |
| `aemo_nemweb_download()` | Raw zipped-CSV download from NEMweb | - |
| `aemo_cache_info()`, `aemo_clear_cache()` | Cache management | - |
| `aemo_throttle()` | Request-rate configuration | - |

## Size guards

AEMO's bid tables are large. `BIDPEROFFER_D` (per-interval bid price and volume bands) has monthly archives of 1.5 to 3 GB zipped. A naive full-year pull is tens of gigabytes of compressed data and tens of millions of rows.

`aemo_bids()` enforces a 30-day span guard by default and refuses longer spans without explicit consent:

```r
# Works (1-day span)
aemo_bids(duid = "BW01", start = "2024-06-01", end = "2024-06-02")

# Errors with a clear message
aemo_bids(duid = "BW01", start = "2024-01-01", end = "2024-06-01")
# Error: Requested span is 152 days.
# Bids data is large (BIDPEROFFER_D monthly = 1.5-3 GB zipped).
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

Attribution on derivative work: *Source: AEMO*.

## Known limitations

- **No WEMDE (Western Australia post-October 2023).** The WEM uses a different data model. Planned for a future release.
- **No 4-second FCAS.** The sub-second FCAS files are hundreds of MB per day and niche. Planned for a future release.
- **No ISP, GSOO, or IASR forecast workbooks.** AEMO's long-run planning studies are published as XLSX supplements to multi-hundred-page PDFs. Each one is a bespoke scrape.
- **Known upstream gap.** AEMO has a documented gap in `BIDPEROFFER_D` between March 2021 and July 2024. Expect missing observations across that span.
- **NEMweb migration 30 April 2026.** AEMO has flagged base URL changes. The package uses `options(aemo.base_url = ...)` so you can point at a new host without reinstalling.
- **Schema drift.** `DISPATCHLOAD` added columns in October 2020 (v4 to v5). The `I,` header row in each file is the source of truth, so the parser handles this transparently, but you should still inspect `names(df)` before any cross-MMSDM-version join.

## Related packages

**Python equivalent:** UNSW-CEEM's [NEMOSIS](https://github.com/UNSW-CEEM/NEMOSIS) is the established Python library for NEM data. Use it if you're in Python.

**R ecosystem:**

- [**carbondata**](https://github.com/charlescoverdale/carbondata): global carbon markets (EU ETS, UK ETS, RGGI, California, Verra)
- [**cer**](https://github.com/charlescoverdale/cer): Australian Clean Energy Regulator (ACCUs, Safeguard, NGER, LRET, SRES)
- [**climatekit**](https://github.com/charlescoverdale/climatekit): climate and weather indices
- [**readnoaa**](https://github.com/charlescoverdale/readnoaa): NOAA weather data
- [**readaec**](https://github.com/charlescoverdale/readaec): Australian Electoral Commission

## History

The `aemo` package name was previously held by Imanuel Costigan's package, which was on CRAN from June 2014 to April 2020 (v0.1.0 to v0.3.0) and archived on 29 December 2021. That package implemented three functions covering prices and demand only. This rewrite is an independent implementation that shares only the package name, and expands scope to the full NEMweb and MMSDM data surface.

## Citation

```r
citation("aemo")
```
