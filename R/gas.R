#' Gas market data (STTM, DWGM)
#'
#' Returns Short Term Trading Market (`STTM`, Adelaide, Brisbane,
#' Sydney hubs) or Declared Wholesale Gas Market (`DWGM`,
#' Victoria) prices and volumes.
#'
#' @param market One of `"sttm"` (default) or `"dwgm"`.
#' @param hub Optional STTM hub: `"adelaide"`, `"brisbane"`, or
#'   `"sydney"`. Ignored for DWGM.
#' @param start,end Window.
#'
#' @return An `aemo_tbl`.
#'
#' @family gas
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   g <- aemo_gas(market = "sttm", hub = "sydney",
#'                  start = now - 7 * 86400, end = now)
#'   head(g)
#' })
#' options(op)
#' }
aemo_gas <- function(market = c("sttm", "dwgm"),
                      hub = NULL, start, end) {
  market <- match.arg(market)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  if (market == "sttm") {
    current <- "/Reports/Current/STTM/"
    archive <- "/Reports/Archive/STTM/"
    pattern <- "STTM"
  } else {
    current <- "/Reports/Current/VicGas/"
    archive <- "/Reports/Archive/VicGas/"
    pattern <- "VICGAS"
  }

  df <- aemo_fetch_report_range(
    current_dir = current, archive_dir = archive,
    pattern = pattern, start = start, end = end
  )
  df <- aemo_coerce_types(df)
  # Gas tables use GASDATE / INTERVAL_DATETIME rather than
  # settlementdate; normalise for the filter step.
  for (alias in c("gasdate", "interval_datetime")) {
    if (!"settlementdate" %in% names(df) && alias %in% names(df)) {
      df$settlementdate <- df[[alias]]
      break
    }
  }
  df <- aemo_apply_filters(df, start = start, end = end)

  if (market == "sttm" && !is.null(hub) && "hubid" %in% names(df)) {
    df <- df[toupper(df$hubid) %in% toupper(hub), , drop = FALSE]
    rownames(df) <- NULL
  }
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO ", market, " gas"))
}
