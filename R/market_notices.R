# MARKETNOTICEDATA feed

#' NEM market notices
#'
#' Returns the `MARKETNOTICEDATA` feed from MMSDM. Market
#' notices are AEMO's free-text log of market-relevant events:
#' Lack of Reserve (LOR1/2/3) declarations, Reliability and
#' Emergency Reserve Trader (RERT) activations, market
#' suspensions, market directions, unit withdrawals, system
#' security events, administered price declarations, and
#' operator advisories.
#'
#' Pair with [aemo_constraints()] and [aemo_price()] to sequence
#' the causal chain of a price event. Rangarajan, Svec, Foley
#' and Trück (2025, *Energy Economics* 141) use
#' `MARKETNOTICEDATA` to order the intervention messages that
#' mark entry to and exit from the June 2022 NEM suspension.
#'
#' @param start,end Window (inclusive) applied to `EFFECTIVEDATE`.
#' @param notice_type Optional character vector (e.g. `"LOR1"`,
#'   `"RERT"`, `"PRICES SUBJECT TO REVIEW"`). Case-insensitive
#'   substring match.
#' @param region Optional NEM region code.
#'
#' @return An `aemo_tbl` with columns from MARKETNOTICEDATA:
#'   `noticeid`, `effectivedate`, `typeid` (notice category),
#'   `originator`, `priority`, `reason` (the notice text),
#'   `externalreference`, and where present `regionid`.
#'
#' @source AEMO NEMweb MMSDM archive, MARKETNOTICEDATA table.
#'   AEMO Copyright Permissions Notice.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   # LOR declarations during the June 2022 NEM suspension
#'   n <- aemo_market_notices(
#'     start = "2022-06-13",
#'     end   = "2022-06-14",
#'     notice_type = "LOR"
#'   )
#'   head(n)
#' })
#' options(op)
#' }
aemo_market_notices <- function(start, end,
                                 notice_type = NULL,
                                 region = NULL) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)
  if (!is.null(region)) region <- aemo_validate_region(region)

  months_needed <- unique(format(
    seq(as.Date(start, tz = AEMO_TIMEZONE),
        as.Date(end,   tz = AEMO_TIMEZONE),
        by = "month"),
    "%Y-%m"
  ))

  all_parts <- list()
  for (ym in months_needed) {
    y <- substr(ym, 1L, 4L)
    m <- substr(ym, 6L, 7L)
    url <- aemo_mmsdm_url("MARKETNOTICEDATA", y, m)
    df <- tryCatch({
      zip_path <- aemo_download_cached(url)
      tmp <- tempfile("aemo_mn_")
      dir.create(tmp, recursive = TRUE)
      on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
      utils::unzip(zip_path, exdir = tmp)
      csvs <- list.files(tmp, pattern = "\\.[Cc][Ss][Vv]$", full.names = TRUE)
      if (length(csvs) == 0L) stop("no csv")
      parsed <- aemo_parse_csv(csvs[[1L]])
      parsed[[1L]]
    }, error = function(e) NULL)
    if (!is.null(df) && nrow(df) > 0L) {
      all_parts[[length(all_parts) + 1L]] <- df
    }
  }

  if (length(all_parts) == 0L) {
    cli::cli_abort(c(
      "Could not retrieve MARKETNOTICEDATA from MMSDM.",
      "i" = "Requested months: {.val {months_needed}}. Check your connection or try {.fn aemo_nemweb_download} with an MMSDM URL."
    ))
  }
  common <- Reduce(intersect, lapply(all_parts, names))
  df <- do.call(rbind, lapply(all_parts, function(d) d[, common, drop = FALSE]))
  df <- aemo_coerce_types(df)

  # Window filter on effectivedate (the canonical timestamp on this table).
  ts_col <- intersect(c("effectivedate", "lastchanged"), names(df))[1L]
  if (!is.na(ts_col)) {
    ts <- if (inherits(df[[ts_col]], "POSIXct")) df[[ts_col]] else
      aemo_parse_col_time(df[[ts_col]])
    keep <- !is.na(ts) & ts >= start & ts <= end
    df <- df[keep, , drop = FALSE]
  }

  if (!is.null(notice_type)) {
    type_cols <- intersect(c("typeid", "noticetype", "reason"), names(df))
    if (length(type_cols) > 0L) {
      haystack <- do.call(paste, c(lapply(type_cols, function(c) df[[c]]),
                                    sep = " "))
      needle <- paste(toupper(notice_type), collapse = "|")
      keep <- grepl(needle, toupper(haystack))
      df <- df[keep, , drop = FALSE]
    }
  }
  if (!is.null(region) && "regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM market notices (MARKETNOTICEDATA)")
}
