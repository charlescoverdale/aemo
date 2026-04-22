#' Rooftop PV actuals and forecasts
#'
#' Returns AEMO's region-level estimate of rooftop PV generation
#' (aggregate small-scale solar), either actuals or forecasts.
#' Published at 30-minute resolution.
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
#'   r <- aemo_rooftop_pv("NSW1",
#'                         start = "2024-06-01",
#'                         end = "2024-06-01 12:00:00")
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

  dir <- if (type == "actual") "ROOFTOP_PV/ACTUAL" else "ROOFTOP_PV/FORECAST"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) {
    cli::cli_abort("No rooftop PV {type} files found.")
  }
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if ("regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO rooftop PV ", type, " ", region))
}
