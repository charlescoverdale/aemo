#' NEM interconnector flows
#'
#' Returns MW flows, losses, and limits for one or more NEM
#' interconnectors from `DISPATCHINTERCONNECTORRES`.
#'
#' AEMO's `METEREDMWFLOW` is positive when power flows from
#' `REGIONFROM` to `REGIONTO`. For per-interconnector direction
#' conventions see [aemo_interconnectors()].
#'
#' @param flow Optional character vector of interconnector IDs.
#' @param start,end Window.
#' @param intervention Logical. Default `FALSE`.
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
#'   i <- aemo_interconnector(flow = "V-SA",
#'                             start = now - 3600, end = now)
#'   head(i)
#' })
#' options(op)
#' }
aemo_interconnector <- function(flow = NULL, start, end,
                                 intervention = FALSE) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  df <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/DispatchIS_Reports/",
    archive_dir = "/Reports/Archive/DispatchIS_Reports/",
    pattern = "DISPATCHIS",
    start = start, end = end,
    table = "dispatch_interconnectorres"
  )
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end,
                           intervention = intervention)

  if (!is.null(flow) && "interconnectorid" %in% names(df)) {
    df <- df[toupper(df$interconnectorid) %in% toupper(flow), ,
             drop = FALSE]
    rownames(df) <- NULL
  }
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "AEMO interconnector flows")
}
