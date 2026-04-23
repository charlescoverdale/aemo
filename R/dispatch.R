#' Per-DUID dispatch output
#'
#' Returns 5-minute SCADA output or dispatch target MW for one
#' or more generator units identified by DUID (Dispatchable Unit
#' Identifier). Timestamps are AEST (UTC+10, no DST).
#'
#' @param duid Optional character vector of DUIDs. `NULL` returns
#'   all generators.
#' @param start,end Window (inclusive).
#' @param measure One of `"scada_mw"` (actual output from
#'   DISPATCH_UNIT_SCADA, default) or `"target_mw"` (dispatch
#'   target from DISPATCHLOAD).
#'
#' @return An `aemo_tbl` with columns `settlementdate`, `duid`,
#'   and the requested measure.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   d <- aemo_dispatch_units(duid = "BW01", start = now - 3600,
#'                             end = now)
#'   head(d)
#' })
#' options(op)
#' }
aemo_dispatch_units <- function(duid = NULL, start, end,
                                 measure = c("scada_mw", "target_mw")) {
  measure <- match.arg(measure)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

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
    svc_cols <- paste0(tolower(service), "mw")
    svc_cols <- intersect(svc_cols, FCAS_ENABLEMENT_COLS)
    if (length(svc_cols) == 0L) {
      cli::cli_abort(c(
        "No matching FCAS service columns found.",
        "i" = "Valid services: {.val {sub('mw$', '', FCAS_ENABLEMENT_COLS)}}."
      ))
    }
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
