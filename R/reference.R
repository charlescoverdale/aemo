# Reference tables (static + live fetch)

#' NEM regions
#'
#' Returns a static table of the five NEM regions with metadata.
#' The `market_timezone` column is the AEMO market clock (AEST,
#' UTC+10, no DST, year-round) that applies to every timestamp
#' in NEMweb files; `wall_timezone` is the local civil time zone
#' consumers experience (observes DST in NSW/VIC/TAS/SA).
#'
#' @return An `aemo_tbl` with columns `region`, `name`, `state`,
#'   `wall_timezone`, `market_timezone`, `commenced`.
#'
#' @family reference
#' @export
#' @examples
#' aemo_regions()
aemo_regions <- function() {
  df <- data.frame(
    region = c("NSW1", "QLD1", "SA1", "TAS1", "VIC1"),
    name = c("New South Wales", "Queensland", "South Australia",
             "Tasmania", "Victoria"),
    state = c("NSW", "QLD", "SA", "TAS", "VIC"),
    wall_timezone = c("Australia/Sydney", "Australia/Brisbane",
                      "Australia/Adelaide", "Australia/Hobart",
                      "Australia/Melbourne"),
    market_timezone = rep(AEMO_TIMEZONE, 5L),
    commenced = as.Date(c("1998-12-13", "1998-12-13", "1998-12-13",
                           "2005-05-29", "1998-12-13")),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "NEM regions")
}

#' NEM interconnectors
#'
#' Returns a static table of the seven NEM interconnectors. The
#' seventh entry is Project EnergyConnect (PEC), whose Stage 1
#' was energised on 30 April 2025 with full ~800 MW capability
#' expected mid-2026.
#'
#' @return An `aemo_tbl` with columns `interconnector_id`,
#'   `from_region`, `to_region`, `name`, `energised`.
#'
#' @family reference
#' @export
#' @examples
#' aemo_interconnectors()
aemo_interconnectors <- function() {
  df <- data.frame(
    interconnector_id = c("NSW1-QLD1", "VIC1-NSW1", "V-S-MNSP1",
                          "V-SA", "T-V-MNSP1", "N-Q-MNSP1",
                          "V-S-N"),
    from_region = c("NSW1", "VIC1", "VIC1", "VIC1", "TAS1", "NSW1",
                    "NSW1"),
    to_region = c("QLD1", "NSW1", "SA1", "SA1", "VIC1", "QLD1",
                  "SA1"),
    name = c("NSW-QLD Interconnector (QNI)",
             "VIC-NSW Interconnector (VNI)",
             "Murraylink",
             "Heywood Interconnector",
             "Basslink",
             "Terranora (Directlink)",
             "Project EnergyConnect (PEC)"),
    energised = as.Date(c("2001-02-18", "1989-01-01", "2002-10-03",
                          "1990-11-01", "2006-04-29", "2000-12-14",
                          "2025-04-30")),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "NEM interconnectors")
}

#' NEM generators (DUID registry)
#'
#' Downloads the current DUDETAILSUMMARY table from the most
#' recent MMSDM monthly archive and returns one row per
#' registered DUID (Dispatchable Unit Identifier) with station,
#' region, dispatch type, classification, and schedule type.
#' Typical output is 500+ DUIDs covering scheduled,
#' semi-scheduled, and non-scheduled generators, bidirectional
#' storage (BESS), and loads.
#'
#' If the MMSDM archive is unreachable, the function returns a
#' 12-row fallback table of well-known DUIDs and emits a warning.
#'
#' @return An `aemo_tbl` keyed by `duid`. Columns include (from
#'   DUDETAILSUMMARY): `duid`, `stationid`, `regionid`,
#'   `dispatchtype` (GENERATOR / LOAD), `connectionpointid`,
#'   `schedule_type` (SCHEDULED / SEMI-SCHEDULED /
#'   NON-SCHEDULED), `start_date`, `end_date`.
#'
#' @source AEMO NEMweb MMSDM archive, DUDETAILSUMMARY table,
#'   AEMO Copyright Permissions Notice.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   u <- aemo_units()
#'   head(u)
#' })
#' options(op)
#' }
aemo_units <- function() {
  df <- tryCatch(aemo_fetch_dudetailsummary(),
                 error = function(e) NULL)
  if (is.null(df) || nrow(df) < 50L) {
    cli::cli_warn(c(
      "Could not reach MMSDM DUDETAILSUMMARY; returning fallback table.",
      "i" = "The fallback covers 12 well-known DUIDs only."
    ))
    fallback <- data.frame(
      duid = c("BW01", "BW02", "BW03", "BW04", "ER01", "ER02",
               "LD01", "LD02", "LD03", "LD04",
               "HVDCLINK", "SWANB_E"),
      station = c(rep("Bayswater", 4L), rep("Eraring", 2L),
                  rep("Liddell (retired 2023)", 4L),
                  "Basslink", "Swanbank E"),
      region = c(rep("NSW1", 10L), "TAS1", "QLD1"),
      fuel = c(rep("Black Coal", 10L), "Interconnector", "Natural Gas"),
      capacity_mw = c(rep(660, 4L), rep(720, 2L), rep(500, 4L),
                      500, 385),
      stringsAsFactors = FALSE
    )
    return(new_aemo_tbl(fallback,
                        source = "http://nemweb.com.au",
                        licence = "AEMO Copyright Permissions Notice",
                        title = "NEM generator registry (fallback)"))
  }
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("NEM DUID registry (DUDETAILSUMMARY, ",
                              format(Sys.Date(), "%Y-%m"), ")"))
}

#' Fetch DUDETAILSUMMARY from the most recent MMSDM archive.
#'
#' MMSDM publishes a monthly snapshot of all AEMO Market Systems
#' tables. DUDETAILSUMMARY captures the registration metadata
#' for every DUID. We try the last several months (MMSDM lags
#' roughly two months) and parse the first zip that returns a
#' table with `>= 50` rows.
#' @noRd
aemo_fetch_dudetailsummary <- function(max_months_back = 6L) {
  now <- Sys.time()
  attr(now, "tzone") <- AEMO_TIMEZONE
  base <- "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM"
  for (offset in 1:max_months_back) {
    target <- seq(as.Date(now) - (offset * 30L),
                  by = "day", length.out = 1L)
    y <- format(target, "%Y")
    m <- format(target, "%m")
    url <- sprintf(
      "%s/%s/MMSDM_%s_%s/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DUDETAILSUMMARY_%s%s010000.zip",
      base, y, y, m, y, m
    )
    df <- tryCatch({
      zip_path <- aemo_download_cached(url)
      tmp <- tempfile("aemo_dudet_")
      dir.create(tmp, recursive = TRUE)
      on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
      utils::unzip(zip_path, exdir = tmp)
      csvs <- list.files(tmp, pattern = "\\.[Cc][Ss][Vv]$",
                         full.names = TRUE)
      if (length(csvs) == 0L) stop("no csv in zip")
      parsed <- aemo_parse_csv(csvs[1L])
      parsed[[1L]]
    }, error = function(e) NULL)
    if (!is.null(df) && nrow(df) >= 50L) {
      df <- aemo_coerce_types(df)
      return(df)
    }
  }
  NULL
}
