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
#' @noRd
aemo_fetch_dudetailsummary <- function(max_months_back = 6L) {
  aemo_fetch_mmsdm_table("DUDETAILSUMMARY", min_rows = 50L,
                          max_months_back = max_months_back)
}

#' NEM market participants and their registered DUIDs
#'
#' Returns a mapping of NEM market participants (companies) to
#' their registered Dispatchable Unit Identifiers (DUIDs), joined
#' from the MMSDM `PARTICIPANT` and `DUDETAILSUMMARY` tables.
#' Use this for corporate ownership analysis: rolling up generator
#' output or bids from DUID-level data to the company level.
#'
#' @return An `aemo_tbl` with columns `participantid`,
#'   `participantclassid` (e.g. `GENERATOR`, `LOAD`, `TRADER`),
#'   `name` (company name), `duid`, `stationid`, `regionid`,
#'   `dispatchtype`, `schedule_type`. Rows are one per
#'   participant-DUID combination. If MMSDM is unreachable,
#'   returns an empty table with a warning.
#'
#' @source AEMO NEMweb MMSDM archive, PARTICIPANT and
#'   DUDETAILSUMMARY tables. AEMO Copyright Permissions Notice.
#'
#' @seealso [aemo_units()] for DUID-level registry without
#'   participant mapping.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   pt <- aemo_participants()
#'   # DUIDs owned by AGL
#'   pt[grepl("AGL", pt$name, ignore.case = TRUE), ]
#' })
#' options(op)
#' }
aemo_participants <- function() {
  duids <- tryCatch(aemo_fetch_dudetailsummary(),
                    error = function(e) NULL)
  parts <- tryCatch(aemo_fetch_participant(),
                    error = function(e) NULL)

  if (is.null(duids) || nrow(duids) < 50L) {
    cli::cli_warn(c(
      "Could not reach MMSDM DUDETAILSUMMARY; returning empty participant table.",
      "i" = "Check your internet connection."
    ))
    empty <- data.frame(
      participantid = character(0L), participantclassid = character(0L),
      name = character(0L), duid = character(0L),
      stationid = character(0L), regionid = character(0L),
      dispatchtype = character(0L), schedule_type = character(0L),
      stringsAsFactors = FALSE
    )
    return(new_aemo_tbl(empty,
                        source = "https://nemweb.com.au",
                        title = "NEM market participants (empty - MMSDM unreachable)"))
  }

  # Join participant metadata onto DUID registry
  if (!is.null(parts) && nrow(parts) >= 1L &&
      "participantid" %in% names(parts) &&
      "participantid" %in% names(duids)) {
    # Keep only columns we want to expose from each table
    part_cols <- intersect(c("participantid", "participantclassid", "name"),
                           names(parts))
    duid_cols <- intersect(c("participantid", "duid", "stationid",
                              "regionid", "dispatchtype", "schedule_type",
                              "start_date", "end_date"),
                            names(duids))
    df <- merge(
      parts[, part_cols, drop = FALSE],
      duids[, duid_cols, drop = FALSE],
      by = "participantid", all.y = TRUE
    )
  } else {
    # No participant table; return DUID registry with participantid only
    duid_cols <- intersect(c("participantid", "duid", "stationid",
                              "regionid", "dispatchtype", "schedule_type"),
                            names(duids))
    df <- duids[, duid_cols, drop = FALSE]
    if (!"name" %in% names(df)) df$name <- NA_character_
  }
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = paste0("NEM participants + DUIDs (MMSDM, ",
                              format(Sys.Date(), "%Y-%m"), ")"))
}

#' Fetch PARTICIPANT table from the most recent MMSDM archive.
#' @noRd
aemo_fetch_participant <- function(max_months_back = 6L) {
  aemo_fetch_mmsdm_table("PARTICIPANT", min_rows = 1L,
                          max_months_back = max_months_back)
}
