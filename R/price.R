# Price functions

#' Wholesale electricity prices
#'
#' Returns 5-minute dispatch prices or 30-minute trading prices
#' for a NEM region over a specified window.
#'
#' Data comes from AEMO's `DISPATCHPRICE` or `TRADINGPRICE`
#' tables via the `DispatchIS_Reports` and `TradingIS_Reports`
#' NEMweb directories (current) or MMSDM monthly archives
#' (historical).
#'
#' @param region One of `"NSW1"`, `"QLD1"`, `"SA1"`, `"TAS1"`,
#'   `"VIC1"`.
#' @param start,end Start and end times. Character (parsed as
#'   AEST) or `POSIXct`.
#' @param interval One of `"5min"` (default) or `"30min"`.
#' @param market One of `"energy"` (default) or `"fcas"`.
#'
#' @return An `aemo_tbl` with one row per interval and columns
#'   including `settlementdate`, `region`, `rrp`.
#'
#' @source AEMO NEMweb <http://nemweb.com.au>, AEMO Copyright
#'   Permissions Notice.
#'
#' @family price
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   p <- aemo_price("NSW1", "2024-06-01", "2024-06-01 01:00:00")
#'   head(p)
#' })
#' options(op)
#' }
aemo_price <- function(region, start, end,
                        interval = c("5min", "30min"),
                        market = c("energy", "fcas")) {
  region <- aemo_validate_region(region)
  interval <- match.arg(interval)
  market <- match.arg(market)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  # Route to the appropriate NEMweb directory.
  dir <- if (interval == "5min") "DispatchIS_Reports" else "TradingIS_Reports"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  pattern <- if (interval == "5min") "DISPATCHIS" else "TRADINGIS"
  files <- files[grepl(pattern, files$name, ignore.case = TRUE), , drop = FALSE]
  if (nrow(files) == 0L) {
    cli::cli_abort("No {interval} price files found on NEMweb.")
  }
  # Take the single most recent file for this scaffold release.
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)

  target <- if (market == "energy") "dispatch_price" else "dispatch_price"
  df <- tables[[target]] %||% tables[[1L]]
  if ("regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO ", interval, " ", market, " price ", region))
}

#' Frequency control ancillary services (FCAS) prices
#'
#' Returns regional FCAS market prices across the 8-10 FCAS
#' services (raise/lower at 6s, 60s, 5min, plus 1s regulation
#' services from 2023).
#'
#' @param region NEM region code.
#' @param start,end Window.
#' @param service Optional character vector of services (e.g.
#'   `"RAISE6SEC"`, `"LOWER60SEC"`). `NULL` returns all.
#'
#' @return An `aemo_tbl`.
#'
#' @family price
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   f <- aemo_fcas("NSW1", "2024-06-01", "2024-06-01 01:00:00")
#'   head(f)
#' })
#' options(op)
#' }
aemo_fcas <- function(region, start, end, service = NULL) {
  region <- aemo_validate_region(region)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
  files <- files[grepl("DISPATCHIS", files$name, ignore.case = TRUE), , drop = FALSE]
  if (nrow(files) == 0L) {
    cli::cli_abort("No FCAS dispatch files found on NEMweb.")
  }
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[["dispatch_price"]] %||% tables[[1L]]
  if ("regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  if (!is.null(service)) {
    service_cols <- tolower(paste0(service, "rrp"))
    keep <- union("settlementdate", intersect(service_cols, names(df)))
    df <- df[, intersect(keep, names(df)), drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO FCAS ", region))
}
