#' NEM interconnector flows
#'
#' Returns MW flows, losses, and limits for one or more NEM
#' interconnectors from the `INTERCONNECTORRES` table.
#'
#' @param flow Optional character vector of interconnector IDs
#'   (see [aemo_interconnectors()]). `NULL` returns all.
#' @param start,end Window.
#'
#' @return An `aemo_tbl`.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   i <- aemo_interconnector(flow = "NSW1-QLD1",
#'                             start = "2024-06-01",
#'                             end = "2024-06-01 01:00:00")
#'   head(i)
#' })
#' options(op)
#' }
aemo_interconnector <- function(flow = NULL, start, end) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
  files <- files[grepl("DISPATCHIS", files$name, ignore.case = TRUE), , drop = FALSE]
  if (nrow(files) == 0L) cli::cli_abort("No interconnector files found.")
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[["dispatch_interconnectorres"]] %||% tables[[1L]]

  if (!is.null(flow) && "interconnectorid" %in% names(df)) {
    df <- df[toupper(df$interconnectorid) %in% toupper(flow), , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = "AEMO interconnector flows")
}
