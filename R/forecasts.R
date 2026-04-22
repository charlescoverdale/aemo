# Predispatch and PASA forecasts

#' Price and demand forecasts (P5MIN, PREDISPATCH, PD7DAY)
#'
#' Returns AEMO's forecast prices and demand for a region out to
#' 5 minutes (`P5MIN`), 40 hours (`PREDISPATCH`), or 7 days
#' (`PD7DAY`).
#'
#' @param region NEM region code.
#' @param as_of Optional `POSIXct` or `"latest"`. Which forecast
#'   run to retrieve.
#' @param horizon One of `"p5min"`, `"predispatch"` (default), or
#'   `"pd7day"`.
#'
#' @return An `aemo_tbl`.
#'
#' @family forecast
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   p <- aemo_predispatch("NSW1")
#'   head(p)
#' })
#' options(op)
#' }
aemo_predispatch <- function(region, as_of = "latest",
                              horizon = c("predispatch", "p5min", "pd7day")) {
  region <- aemo_validate_region(region)
  horizon <- match.arg(horizon)

  dir <- switch(horizon,
    predispatch = "PredispatchIS_Reports",
    p5min       = "P5_Reports",
    pd7day      = "PredispatchIS_Reports"
  )
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) cli::cli_abort("No {horizon} files found.")
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if ("regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO ", horizon, " ", region))
}

#' Projected Assessment of System Adequacy (PASA)
#'
#' Returns short-term (`STPASA`, 1-7 days) or medium-term
#' (`MTPASA`, 2 years) system adequacy projections.
#'
#' @param horizon One of `"short"` (default, `STPASA`) or
#'   `"medium"` (`MTPASA`).
#' @param region Optional NEM region code to filter.
#' @param as_of Optional `"latest"` or `POSIXct`.
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
#'   head(p)
#' })
#' options(op)
#' }
aemo_pasa <- function(horizon = c("short", "medium"),
                       region = NULL, as_of = "latest") {
  horizon <- match.arg(horizon)
  if (!is.null(region)) region <- aemo_validate_region(region)

  dir <- if (horizon == "short") "Short_Term_PASA_Reports" else "Medium_Term_PASA_Reports"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) cli::cli_abort("No PASA files found.")
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if (!is.null(region) && "regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO ", horizon, "-term PASA"))
}
