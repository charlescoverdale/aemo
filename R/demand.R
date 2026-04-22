#' Regional electricity demand
#'
#' Returns 5-minute regional demand from `DISPATCHREGIONSUM`.
#'
#' @param region NEM region code.
#' @param start,end Window.
#' @param measure One of `"operational"` (total demand including
#'   auxiliary loads, default), `"operational_less_snsg"`
#'   (excluding small non-scheduled generation), or `"native"`.
#'
#' @return An `aemo_tbl`.
#'
#' @source AEMO NEMweb, AEMO Copyright Permissions Notice.
#'
#' @family demand
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   d <- aemo_demand("VIC1", "2024-06-01", "2024-06-01 01:00:00")
#'   head(d)
#' })
#' options(op)
#' }
aemo_demand <- function(region, start, end,
                         measure = c("operational",
                                     "operational_less_snsg",
                                     "native")) {
  region <- aemo_validate_region(region)
  measure <- match.arg(measure)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
  files <- files[grepl("DISPATCHIS", files$name, ignore.case = TRUE), , drop = FALSE]
  if (nrow(files) == 0L) cli::cli_abort("No dispatch files found.")
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[["dispatch_regionsum"]] %||% tables[[1L]]
  if ("regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO demand ", region, " (", measure, ")"))
}
