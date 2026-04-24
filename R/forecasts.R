# Predispatch and PASA forecasts

#' Price and demand forecasts (P5MIN, PREDISPATCH)
#'
#' Returns AEMO's forecast prices and demand for a NEM region.
#' Two horizons:
#' - `"p5min"`: 5-minute-ahead forecast, 12 intervals ahead,
#'   published every 5 minutes.
#' - `"predispatch"`: 40-hour-ahead predispatch at 30-minute
#'   resolution, published every 30 minutes.
#'
#' The 7-day predispatch publication was retired when 5-minute
#' settlement commenced; for longer horizons use [aemo_pasa()].
#'
#' **Vintages.** PREDISPATCH and P5MIN forecasts are re-issued
#' every 30 or 5 minutes respectively. Every vintage is archived
#' by its `RUN_DATETIME`. By default (`run_datetime = NULL`) this
#' function returns all vintages whose *file* timestamp falls in
#' `[start, end]`, i.e. all the forecasts *issued* during the
#' window. The `periodid` / `datetime` columns on the returned
#' rows give each forecast's *target* time.
#'
#' For forecast-error research (comparing a forecast vintage
#' against the realised dispatch) pass `run_datetime` to pin a
#' specific vintage:
#'
#' ```r
#' # The PREDISPATCH run issued at 15:00 on 1 June 2024 --
#' # 80 half-hour-ahead rows covering 15:30 out to 31:30 hours.
#' v <- aemo_predispatch("NSW1", start = "2024-06-01", end = "2024-06-02",
#'                       run_datetime = "2024-06-01 15:00")
#' ```
#'
#' This is the vintage-aware pattern used in Prakash (2023)
#' *NEMSEER* (JOSS 8(92) 5883).
#'
#' @param region NEM region code.
#' @param start,end Window of forecast run-times.
#' @param horizon One of `"predispatch"` (default) or `"p5min"`.
#' @param run_datetime Optional character or `POSIXct`. A specific
#'   `RUN_DATETIME` to pin to. `NULL` (default) returns every
#'   vintage issued in `[start, end]`.
#'
#' @return An `aemo_tbl`.
#'
#' @family forecast
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   p <- aemo_predispatch("NSW1", start = now - 3600, end = now)
#'   head(p)
#' })
#' options(op)
#' }
aemo_predispatch <- function(region, start, end,
                              horizon = c("predispatch", "p5min"),
                              run_datetime = NULL) {
  region <- aemo_validate_region(region)
  horizon <- match.arg(horizon)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  if (horizon == "predispatch") {
    current <- "/Reports/Current/PredispatchIS_Reports/"
    archive <- "/Reports/Archive/PredispatchIS_Reports/"
    pattern <- "PREDISPATCHIS"
  } else {
    current <- "/Reports/Current/P5_Reports/"
    archive <- "/Reports/Archive/P5_Reports/"
    pattern <- "P5MIN"
  }

  df <- aemo_fetch_report_range(
    current_dir = current, archive_dir = archive,
    pattern = pattern, start = start, end = end
  )
  df <- aemo_coerce_types(df)
  # Do NOT filter on settlementdate here: forecast rows have target
  # datetimes that extend well past the [start, end] run-time window.
  df <- aemo_apply_filters(df, region = region)

  if (!is.null(run_datetime)) {
    run_ts <- aemo_parse_time(run_datetime)
    run_col <- intersect(c("run_datetime", "predispatchseqno",
                            "predispatch_run_datetime"), names(df))[1L]
    if (!is.na(run_col) && inherits(df[[run_col]], "POSIXct")) {
      df <- df[!is.na(df[[run_col]]) & df[[run_col]] == run_ts, ,
               drop = FALSE]
    } else if (!is.na(run_col)) {
      # Character match on a pre-coerced run datetime column
      target <- format(run_ts, "%Y/%m/%d %H:%M:%S")
      df <- df[!is.na(df[[run_col]]) & df[[run_col]] == target, ,
               drop = FALSE]
    }
    rownames(df) <- NULL
  }

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO ", horizon, " ",
                              paste(region, collapse = "+"),
                              if (!is.null(run_datetime))
                                paste0(" @ ", format(aemo_parse_time(run_datetime)))
                              else ""))
}

#' Projected Assessment of System Adequacy (PASA)
#'
#' Returns short-term (`STPASA`, 1-7 day) or medium-term
#' (`MTPASA`, 2-year) system adequacy projections.
#'
#' @param horizon One of `"short"` (default) or `"medium"`.
#' @param region Optional NEM region code.
#' @param start,end Optional window of run-times. Defaults to
#'   the last 24 hours.
#'
#' @return An `aemo_tbl`.
#'
#' @family forecast
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   p <- aemo_pasa(horizon = "short", region = "NSW1")
#' })
#' options(op)
#' }
aemo_pasa <- function(horizon = c("short", "medium"),
                       region = NULL, start = NULL, end = NULL) {
  horizon <- match.arg(horizon)
  if (!is.null(region)) region <- aemo_validate_region(region)
  # Horizon-aware defaults: STPASA is hourly / 1-7 day horizon so a
  # 24-hour lookback makes sense; MTPASA is daily / 2-year horizon
  # published at most once a week, so default to the last 8 days
  # (guaranteed to catch at least one publication).
  if (is.null(end))   end   <- Sys.time()
  if (is.null(start)) {
    lookback <- if (horizon == "short") 1 else 8
    start <- end - as.difftime(lookback, units = "days")
  }
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)

  if (horizon == "short") {
    current <- "/Reports/Current/Short_Term_PASA_Reports/"
    archive <- "/Reports/Archive/Short_Term_PASA_Reports/"
    pattern <- "STPASA"
  } else {
    current <- "/Reports/Current/Medium_Term_PASA_Reports/"
    archive <- "/Reports/Archive/Medium_Term_PASA_Reports/"
    pattern <- "MTPASA"
  }

  df <- aemo_fetch_report_range(
    current_dir = current, archive_dir = archive,
    pattern = pattern, start = start, end = end
  )
  df <- aemo_coerce_types(df)
  # PASA target dates extend past [start, end]; filter on region only.
  df <- aemo_apply_filters(df, region = region)
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO ", horizon, "-term PASA"))
}
