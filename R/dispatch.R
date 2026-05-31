#' Per-DUID dispatch output
#'
#' Returns 5-minute generator output for one or more DUIDs.
#' Three measures are available:
#'
#' - `"scada_mw"` (default): actual metered output from
#'   `DISPATCH_UNIT_SCADA` (`SCADAVALUE`).
#' - `"target_mw"`: dispatch target from `DISPATCHLOAD`
#'   (`TOTALCLEARED`). This is the MW AEMO *asked* the unit to
#'   produce at the end of the interval.
#' - `"both"`: returns `SCADAVALUE`, `INITIALMW` (SCADA at the
#'   start of the interval) and `TOTALCLEARED` (target at the
#'   end) in a single row per DUID per interval. Use this for
#'   ramp-trajectory research: the ramp applied during the
#'   interval is the straight line from `INITIALMW` to
#'   `TOTALCLEARED`.
#'
#' Timestamps are AEST (UTC+10, no DST).
#'
#' @param duid Optional character vector of DUIDs. `NULL` returns
#'   all generators.
#' @param start,end Window (inclusive).
#' @param measure One of `"scada_mw"` (default), `"target_mw"`,
#'   or `"both"`.
#'
#' @return An `aemo_tbl` with columns `settlementdate`, `duid`,
#'   and the requested measure(s).
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   # SCADA actual
#'   d <- aemo_dispatch_units(duid = "BW01", start = now - 3600,
#'                             end = now)
#'
#'   # Paired: INITIALMW, TOTALCLEARED, SCADAVALUE (ramp research)
#'   d_both <- aemo_dispatch_units(duid = "BW01",
#'                                  start = now - 3600, end = now,
#'                                  measure = "both")
#' })
#' options(op)
#' }
aemo_dispatch_units <- function(duid = NULL, start, end,
                                 measure = c("scada_mw", "target_mw",
                                             "both")) {
  measure <- match.arg(measure)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  if (measure == "both") {
    return(aemo_dispatch_units_both(duid = duid, start = start, end = end))
  }

  if (measure == "scada_mw") {
    df <- aemo_fetch_report_range(
      current_dir = "/Reports/Current/Dispatch_SCADA/",
      archive_dir = "/Reports/Archive/Dispatch_SCADA/",
      pattern = "DISPATCHSCADA",
      start = start, end = end
    )
  } else {
    df <- aemo_fetch_report_range(
      current_dir = "/Reports/Current/DispatchIS_Reports/",
      archive_dir = "/Reports/Archive/DispatchIS_Reports/",
      pattern = "DISPATCHIS",
      start = start, end = end,
      table = "dispatch_unit_solution"
    )
  }
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end)

  if (!is.null(duid) && "duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
    rownames(df) <- NULL
  }

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO dispatch units (", measure, ")"))
}

#' Fetch SCADA actual + DISPATCHLOAD initial/target and pair by
#' (duid, settlementdate).
#' @noRd
aemo_dispatch_units_both <- function(duid, start, end) {
  scada <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/Dispatch_SCADA/",
    archive_dir = "/Reports/Archive/Dispatch_SCADA/",
    pattern = "DISPATCHSCADA",
    start = start, end = end
  )
  scada <- aemo_coerce_types(scada)
  scada <- aemo_apply_filters(scada, start = start, end = end)

  load <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/DispatchIS_Reports/",
    archive_dir = "/Reports/Archive/DispatchIS_Reports/",
    pattern = "DISPATCHIS",
    start = start, end = end,
    table = "dispatch_unit_solution"
  )
  load <- aemo_coerce_types(load)
  load <- aemo_apply_filters(load, start = start, end = end)

  if (!is.null(duid)) {
    scada <- scada[toupper(scada$duid) %in% toupper(duid), , drop = FALSE]
    load  <- load[toupper(load$duid)   %in% toupper(duid), , drop = FALSE]
  }

  load_keep <- intersect(c("settlementdate", "duid", "intervention",
                            "initialmw", "totalcleared", "availability",
                            "rampuprate", "rampdownrate",
                            "semidispatchcap"),
                         names(load))
  scada_keep <- intersect(c("settlementdate", "duid", "scadavalue"),
                          names(scada))
  load <- load[, load_keep, drop = FALSE]
  scada <- scada[, scada_keep, drop = FALSE]

  joined <- merge(load, scada,
                   by = intersect(c("settlementdate", "duid"),
                                  intersect(names(load), names(scada))),
                   all.x = TRUE, sort = FALSE)
  rownames(joined) <- NULL
  new_aemo_tbl(joined,
               source = "http://nemweb.com.au",
               title = "AEMO dispatch units (INITIALMW + TOTALCLEARED + SCADAVALUE)")
}

# FCAS service columns in DISPATCHLOAD (10 services as of Oct 2023)
FCAS_ENABLEMENT_COLS <- c(
  "raise1secmw", "lower1secmw",
  "raise6secmw", "lower6secmw",
  "raise60secmw", "lower60secmw",
  "raise5minmw", "lower5minmw",
  "raiseregmw", "lowerregmw"
)

#' FCAS enablement volumes by generator unit
#'
#' Returns the MW enabled for each of the ten Frequency Control
#' Ancillary Services (FCAS) per DUID per 5-minute dispatch
#' interval from `DISPATCHLOAD`. This is the quantity side of
#' the FCAS market: how much each unit was enabled (dispatched)
#' to provide each service, as distinct from the price returned
#' by [aemo_fcas()].
#'
#' Ten services are active since 9 October 2023 when Very Fast
#' (`RAISE1SEC` / `LOWER1SEC`) commenced. Before that date only
#' eight services are present; the `raise1secmw` / `lower1secmw`
#' columns will be `NA` for intervals before that date.
#'
#' @param duid Optional character vector of DUIDs. `NULL` returns
#'   all units. See [aemo_units()] for the full DUID registry.
#' @param start,end Window (inclusive), character or POSIXct.
#' @param service Optional character vector of service names,
#'   e.g. `c("raise6sec", "lowerreg")`. Case-insensitive.
#'   `NULL` returns all ten services.
#' @param intervention Logical. Default `FALSE`.
#'
#' @return An `aemo_tbl` with columns `settlementdate`, `duid`,
#'   and one column per FCAS service (`raise1secmw`,
#'   `lower1secmw`, `raise6secmw`, `lower6secmw`,
#'   `raise60secmw`, `lower60secmw`, `raise5minmw`,
#'   `lower5minmw`, `raiseregmw`, `lowerregmw`). Values are
#'   MW; zero means the unit was not enabled for that service.
#'
#' @source AEMO NEMweb DISPATCHIS_Reports, DISPATCHLOAD table.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   e <- aemo_fcas_enablement(start = now - 3600, end = now)
#'   head(e)
#' })
#' options(op)
#' }
aemo_fcas_enablement <- function(duid = NULL, start, end,
                                  service = NULL,
                                  intervention = FALSE) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  # Validate the service argument before any network request so an
  # unknown service name fails fast (and offline) rather than only
  # after a wasted fetch. svc_cols is reused as the column filter below.
  svc_cols <- NULL
  if (!is.null(service)) {
    svc_cols <- intersect(paste0(tolower(service), "mw"),
                          FCAS_ENABLEMENT_COLS)
    if (length(svc_cols) == 0L) {
      cli::cli_abort(c(
        "No matching FCAS service columns found.",
        "i" = "Valid services: {.val {sub('mw$', '', FCAS_ENABLEMENT_COLS)}}."
      ))
    }
  }

  df <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/DispatchIS_Reports/",
    archive_dir = "/Reports/Archive/DispatchIS_Reports/",
    pattern = "DISPATCHIS",
    start = start, end = end,
    table = "dispatch_unit_solution"
  )
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end,
                           intervention = intervention)

  if (!is.null(duid) && "duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
  }

  keep_cols <- c("settlementdate", "duid", "intervention")
  if (!is.null(service)) {
    keep_cols <- c(keep_cols, svc_cols)
  } else {
    keep_cols <- c(keep_cols, FCAS_ENABLEMENT_COLS)
  }
  if (!intervention) keep_cols <- setdiff(keep_cols, "intervention")
  present <- intersect(keep_cols, names(df))
  df <- df[, present, drop = FALSE]
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "AEMO FCAS enablement volumes (DISPATCHLOAD)")
}
