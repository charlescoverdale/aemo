#' Generator bid stack
#'
#' Returns `BIDDAYOFFER_D` (daily bid summary: MaxAvail, fixed
#' load, 10 price bands) or `BIDPEROFFER_D` (per-interval
#' availability and rebids) for specified generators.
#'
#' **Size warning.** `BIDPEROFFER_D` monthly archives are
#' multi-gigabyte. By default `aemo_bids()` refuses spans longer
#' than 30 days; pass `allow_large = TRUE` to override.
#'
#' **Upstream gap.** AEMO has a documented gap in
#' `BIDPEROFFER_D` between March 2021 and July 2024. Rows in
#' that range may be missing.
#'
#' @param duid Character vector of DUIDs. Required.
#' @param start,end Window.
#' @param resolution One of `"day"` (default, BIDDAYOFFER_D) or
#'   `"period"` (BIDPEROFFER_D, much larger).
#' @param allow_large Logical. Default `FALSE`.
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
#'   b <- aemo_bids(duid = "BW01",
#'                   start = now - 86400, end = now)
#'   head(b)
#' })
#' options(op)
#' }
aemo_bids <- function(duid, start, end,
                      resolution = c("day", "period"),
                      allow_large = FALSE) {
  if (missing(duid) || is.null(duid) || length(duid) == 0L) {
    cli::cli_abort("{.arg duid} is required. Pass at least one DUID.")
  }
  resolution <- match.arg(resolution)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  span_days <- as.numeric(difftime(end, start, units = "days"))
  if (span_days > 30 && !allow_large) {
    cli::cli_abort(c(
      "Requested span is {round(span_days)} days.",
      "i" = "Bids data is large (BIDPEROFFER_D monthly archives are multi-GB zipped).",
      "i" = "Pass {.code allow_large = TRUE} to proceed."
    ))
  }

  if (resolution == "day") {
    current <- "/Reports/Current/Next_Day_Offer_Energy/"
    archive <- "/Reports/Archive/Next_Day_Offer_Energy/"
    pattern <- "NEXT_DAY_OFFER_ENERGY"
  } else {
    current <- "/Reports/Current/Bidmove_Complete/"
    archive <- "/Reports/Archive/Bidmove_Complete/"
    pattern <- "BIDMOVE_COMPLETE"
  }

  df <- aemo_fetch_report_range(
    current_dir = current, archive_dir = archive,
    pattern = pattern, start = start, end = end
  )
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end)

  if ("duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
    rownames(df) <- NULL
  }
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO bids (", resolution, ")"))
}
