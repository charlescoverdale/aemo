#' Generator bid stack
#'
#' Returns `BIDDAYOFFER_D` (daily bid summary) or `BIDPEROFFER_D`
#' (per-interval bid prices and volumes across up to 10 bid
#' bands) for specified generators.
#'
#' **Size warning.** `BIDPEROFFER_D` monthly archives are 1.5-3 GB
#' zipped. By default `aemo_bids()` refuses spans exceeding 30
#' days to protect users. Set `allow_large = TRUE` to override.
#'
#' @param duid Character vector of DUIDs. Required (no default).
#' @param start,end Window.
#' @param resolution One of `"day"` (default, uses
#'   `BIDDAYOFFER_D`) or `"period"` (uses `BIDPEROFFER_D`, much
#'   larger).
#' @param allow_large Logical. Default `FALSE`. Set `TRUE` to
#'   permit spans longer than 30 days.
#'
#' @return An `aemo_tbl`.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   b <- aemo_bids(duid = "BW01",
#'                   start = "2024-06-01",
#'                   end = "2024-06-02")
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
      "i" = "Bids data is large (BIDPEROFFER_D monthly = 1.5-3 GB zipped).",
      "i" = "Pass {.code allow_large = TRUE} to proceed."
    ))
  }

  dir <- if (resolution == "day") "Next_Day_Offer_Energy" else "Bidmove_Complete"
  files <- aemo_nemweb_ls(paste0("/Reports/Current/", dir, "/"))
  if (nrow(files) == 0L) {
    cli::cli_abort("No bid files found in {.val {dir}}.")
  }
  zip_url <- files$url[nrow(files)]
  tables <- aemo_fetch_zip(zip_url)
  df <- tables[[1L]]

  if ("duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = zip_url,
               title = paste0("AEMO bids ", resolution))
}
