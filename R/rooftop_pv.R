#' Rooftop PV actuals and forecasts
#'
#' Returns AEMO's region-level estimate of rooftop PV generation,
#' either actuals or forecasts. Published at 30-minute resolution.
#'
#' The "actual" figure is an AEMO estimate derived from the APVI
#' sampling model and weather data, not metered SCADA output. It
#' is the best available public measure of aggregate rooftop PV
#' generation but is subject to revision.
#'
#' @param region NEM region code.
#' @param start,end Window.
#' @param type One of `"actual"` (default) or `"forecast"`.
#'
#' @return An `aemo_tbl`.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   r <- aemo_rooftop_pv("NSW1",
#'                         start = now - 3600, end = now)
#'   head(r)
#' })
#' options(op)
#' }
aemo_rooftop_pv <- function(region, start, end,
                             type = c("actual", "forecast")) {
  region <- aemo_validate_region(region)
  type <- match.arg(type)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  sub <- if (type == "actual") "ACTUAL" else "FORECAST"
  df <- aemo_fetch_report_range(
    current_dir = paste0("/Reports/Current/ROOFTOP_PV/", sub, "/"),
    archive_dir = paste0("/Reports/Archive/ROOFTOP_PV/", sub, "/"),
    pattern = "ROOFTOP_PV",
    start = start, end = end
  )
  df <- aemo_coerce_types(df)
  # Rooftop PV uses INTERVAL_DATETIME rather than SETTLEMENTDATE.
  if (!"settlementdate" %in% names(df) &&
      "interval_datetime" %in% names(df)) {
    df$settlementdate <- df$interval_datetime
  }
  df <- aemo_apply_filters(df, start = start, end = end, region = region)

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO rooftop PV ", type, " ",
                              paste(region, collapse = "+")))
}
