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
#' Downloads the `DUDETAILSUMMARY` table from the most recent
#' MMSDM monthly archive and returns one row per registered DUID
#' (Dispatchable Unit Identifier) with station, region, dispatch
#' type, classification, and schedule type. Typical output is
#' 500+ DUIDs covering scheduled, semi-scheduled, and
#' non-scheduled generators, bidirectional storage (BESS), and
#' loads.
#'
#' **Effective-date filtering.** `DUDETAILSUMMARY` is
#' effective-dated (`START_DATE`, `END_DATE` per row with
#' multiple `VERSIONNO` vintages per DUID over time). The
#' default (`as_of = NULL`) returns rows whose
#' `[START_DATE, END_DATE]` interval covers the date the MMSDM
#' archive was published: i.e. the *current* registry. Pass an
#' `as_of` date to get the registry as it was on that date
#' (essential for historical analysis: Liddell's four DUIDs
#' were retired in April 2023; pre-2023 queries need them).
#'
#' This matches the as-of-join pattern documented in Gorman et
#' al. (2018) *NEMOSIS* (APSRC) for correct historical joins.
#'
#' @param as_of Optional `Date` or `POSIXct`. Returns the DUID
#'   registry as it was on that date. `NULL` (default) returns
#'   the current registry.
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
#'   # Current DUID registry
#'   u <- aemo_units()
#'
#'   # DUIDs as they were on 1 March 2023 (pre-Liddell retirement)
#'   u_2023 <- aemo_units(as_of = "2023-03-01")
#' })
#' options(op)
#' }
aemo_units <- function(as_of = NULL) {
  df <- tryCatch(aemo_fetch_dudetailsummary(),
                 error = function(e) NULL)
  if (is.null(df) || nrow(df) < 50L) {
    cli::cli_abort(c(
      "Could not retrieve DUDETAILSUMMARY from MMSDM.",
      "i" = "Retry when the MMSDM archive is reachable, or use {.fn aemo_nemweb_download} with an MMSDM URL directly.",
      "i" = "No fallback is provided: a stale or invented DUID registry would silently mislabel historical analyses."
    ))
  }

  if (!is.null(as_of)) {
    as_of_ts <- aemo_parse_time(as_of)
    df <- aemo_filter_as_of(df, as_of = as_of_ts)
  }

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("NEM DUID registry (DUDETAILSUMMARY",
                              if (!is.null(as_of))
                                paste0(", as of ", format(aemo_parse_time(as_of), "%Y-%m-%d"))
                              else paste0(", ", format(Sys.Date(), "%Y-%m")),
                              ")"))
}

#' Apply an effective-date filter on a DUDETAILSUMMARY-style
#' data frame.
#'
#' Selects rows where `start_date <= as_of < end_date`. Uses
#' MMSDM's end-of-time sentinel (2999-12-31) for open-ended
#' records.
#' @noRd
aemo_filter_as_of <- function(df, as_of) {
  start_col <- intersect(c("start_date", "effectivedate",
                            "effectivefrom"), names(df))[1L]
  end_col <- intersect(c("end_date", "enddate", "effectiveto"),
                        names(df))[1L]
  if (is.na(start_col)) return(df)

  start_ts <- if (inherits(df[[start_col]], "POSIXct")) {
    df[[start_col]]
  } else {
    aemo_parse_col_time(df[[start_col]])
  }
  end_ts <- if (!is.na(end_col)) {
    if (inherits(df[[end_col]], "POSIXct")) {
      df[[end_col]]
    } else {
      aemo_parse_col_time(df[[end_col]])
    }
  } else {
    rep(as.POSIXct(NA, tz = AEMO_TIMEZONE), nrow(df))
  }
  # Treat NA or MMSDM sentinel (year 2999) end-dates as open-ended.
  open_end <- is.na(end_ts) |
    format(end_ts, "%Y") %in% c("2999", "9999")
  keep <- !is.na(start_ts) & start_ts <= as_of &
    (open_end | end_ts > as_of)
  df <- df[keep, , drop = FALSE]
  rownames(df) <- NULL
  df
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
