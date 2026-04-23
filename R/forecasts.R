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
#' @param region NEM region code.
#' @param start,end Window of forecast run-times.
#' @param horizon One of `"predispatch"` (default) or `"p5min"`.
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
                              horizon = c("predispatch", "p5min")) {
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
  df <- aemo_apply_filters(df, start = start, end = end, region = region)
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO ", horizon, " ",
                              paste(region, collapse = "+")))
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
  if (is.null(start)) start <- Sys.time() - as.difftime(1, units = "days")
  if (is.null(end))   end   <- Sys.time()
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
  df <- aemo_apply_filters(df, start = start, end = end, region = region)
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO ", horizon, "-term PASA"))
}
