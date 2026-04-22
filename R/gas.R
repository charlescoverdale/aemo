#' Gas market data (STTM, DWGM)
#'
#' Returns Short Term Trading Market (`STTM`, Adelaide/Brisbane/
#' Sydney) or Declared Wholesale Gas Market (`DWGM`, Victoria)
#' prices and volumes.
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
#'   g <- aemo_gas(market = "sttm", hub = "sydney",
#'                  start = "2024-06-01",
#'                  end = "2024-06-02")
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

  dir <- if (market == "sttm") "STTM" else "VicGas"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) cli::cli_abort("No {market} files found.")
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if (market == "sttm" && !is.null(hub) && "hubid" %in% names(df)) {
    df <- df[toupper(df$hubid) %in% toupper(hub), , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO ", market, " gas"))
}
