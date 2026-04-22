#' Per-DUID dispatch output
#'
#' Returns 5-minute SCADA or target MW for one or more generator
#' units identified by DUID (Dispatchable Unit Identifier).
#'
#' @param duid Optional character vector of DUIDs (e.g. `"BW01"`,
#'   `c("ER01", "ER02")`). `NULL` returns all generators in the
#'   current snapshot.
#' @param start,end Window.
#' @param measure One of `"scada_mw"` (actual output, default) or
#'   `"target_mw"` (dispatch target).
#'
#' @return An `aemo_tbl` with columns including `settlementdate`,
#'   `duid`, and the requested measure.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   d <- aemo_dispatch_units(duid = "BW01",
#'                             start = "2024-06-01",
#'                             end = "2024-06-01 01:00:00")
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

  dir <- if (measure == "scada_mw") "Dispatch_SCADA" else "DispatchIS_Reports"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) {
    cli::cli_abort("No dispatch-unit files found on NEMweb.")
  }
  pattern <- if (measure == "scada_mw") "DISPATCHSCADA" else "DISPATCHIS"
  files <- files[grepl(pattern, files$name, ignore.case = TRUE), , drop = FALSE]
  if (nrow(files) == 0L) {
    cli::cli_abort("No matching files on NEMweb for {.val {pattern}}.")
  }
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if (!is.null(duid) && "duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO dispatch units (", measure, ")"))
}
