#' Generator bid stack
#'
#' Returns `BIDDAYOFFER_D` (daily bid summary: 10 price bands,
#' MaxAvail, fixed load, locked at 12:30 D-1), `BIDPEROFFER_D`
#' (per-interval availability and rebids), or the two joined on
#' `(duid, settlementdate, bidtype)`.
#'
#' **Parent / child structure.** `BIDDAYOFFER_D` carries the
#' **price bands** (`priceband1..priceband10`), which are locked
#' at 12:30 on the day ahead and cannot be rebid.
#' `BIDPEROFFER_D` carries the **per-interval availability
#' bands** (`bandavail1..bandavail10`), which can be rebid
#' intraday. Serious bidding analysis (Goncalves & Menezes 2022
#' Energy Economics 113 106398; Nelson et al. 2024 AJARE 68(4))
#' needs both joined.
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
#' @param resolution One of `"day"` (default, BIDDAYOFFER_D
#'   only), `"period"` (BIDPEROFFER_D only), or `"joined"`
#'   (BIDDAYOFFER_D inner-joined to BIDPEROFFER_D on
#'   `(duid, settlementdate, bidtype)`).
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
#'   # Daily bid summary (price bands)
#'   b <- aemo_bids(duid = "BW01",
#'                   start = now - 86400, end = now)
#'
#'   # Joined: price bands + per-interval volumes
#'   bj <- aemo_bids(duid = "BW01", start = now - 86400, end = now,
#'                    resolution = "joined")
#' })
#' options(op)
#' }
aemo_bids <- function(duid, start, end,
                      resolution = c("day", "period", "joined"),
                      allow_large = FALSE) {
  if (missing(duid) || is.null(duid) || length(duid) == 0L) {
    cli::cli_abort("{.arg duid} is required. Pass at least one DUID.")
  }
  resolution <- match.arg(resolution)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  span_days <- as.numeric(difftime(end, start, units = "days"))
  # The size guard applies whenever BIDPEROFFER_D is touched.
  if (resolution %in% c("period", "joined") && span_days > 30 &&
      !allow_large) {
    cli::cli_abort(c(
      "Requested span is {round(span_days)} days.",
      "i" = "Bids data is large (BIDPEROFFER_D monthly archives are multi-GB zipped).",
      "i" = "Pass {.code allow_large = TRUE} to proceed."
    ))
  }

  if (resolution == "joined") {
    return(aemo_bids_joined(duid = duid, start = start, end = end))
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

#' Inner-join BIDDAYOFFER_D (price bands) to BIDPEROFFER_D (volumes).
#'
#' Joins on `(duid, settlementdate, bidtype)`. Returns one row per
#' (duid, 5-min interval, bidtype) with both the locked price
#' bands and the rebiddable volume bands.
#' @noRd
aemo_bids_joined <- function(duid, start, end) {
  # BIDDAYOFFER is pulled for the day range spanning the query.
  day_start <- as.POSIXct(format(start - as.difftime(1, units = "days"),
                                  "%Y-%m-%d 00:00:00"),
                          tz = AEMO_TIMEZONE)
  day_end <- as.POSIXct(format(end + as.difftime(1, units = "days"),
                                "%Y-%m-%d 23:55:00"),
                        tz = AEMO_TIMEZONE)

  day <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/Next_Day_Offer_Energy/",
    archive_dir = "/Reports/Archive/Next_Day_Offer_Energy/",
    pattern = "NEXT_DAY_OFFER_ENERGY",
    start = day_start, end = day_end
  )
  day <- aemo_coerce_types(day)

  per <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/Bidmove_Complete/",
    archive_dir = "/Reports/Archive/Bidmove_Complete/",
    pattern = "BIDMOVE_COMPLETE",
    start = start, end = end
  )
  per <- aemo_coerce_types(per)
  per <- aemo_apply_filters(per, start = start, end = end)

  for (d in list(day, per)) {
    if ("duid" %in% names(d)) {
      # Filter each side to the requested DUIDs before joining.
      assign(if (identical(d, day)) "day" else "per",
             d[toupper(d$duid) %in% toupper(duid), , drop = FALSE])
    }
  }
  day <- day[toupper(day$duid) %in% toupper(duid), , drop = FALSE]
  per <- per[toupper(per$duid) %in% toupper(duid), , drop = FALSE]

  # BIDDAYOFFER carries price bands 1..10; BIDPEROFFER carries bandavail 1..10.
  # Join key: (duid, bidtype) + the trading-day of the per-interval row.
  price_cols <- grep("^priceband\\d+$", names(day), value = TRUE)
  vol_cols   <- grep("^bandavail\\d+$", names(per), value = TRUE)
  day_keep <- intersect(c("duid", "bidtype", "settlementdate",
                           "maxavail", "fixedload", "daaavailability",
                           price_cols),
                         names(day))
  per_keep <- intersect(c("duid", "bidtype", "settlementdate",
                           "offerdate", "maxavail", "rampuprate",
                           "rampdownrate", vol_cols),
                         names(per))

  day <- day[, day_keep, drop = FALSE]
  per <- per[, per_keep, drop = FALSE]
  # Rename BIDDAYOFFER's settlementdate to trading_day for the join;
  # BIDPEROFFER's settlementdate is the 5-min period ending.
  if ("settlementdate" %in% names(day)) {
    day$trading_day <- as.Date(day$settlementdate, tz = AEMO_TIMEZONE)
    day$settlementdate <- NULL
  }
  if ("settlementdate" %in% names(per)) {
    per$trading_day <- as.Date(per$settlementdate, tz = AEMO_TIMEZONE)
  }
  # Suffix collisions handled explicitly: keep BIDPEROFFER's maxavail.
  if ("maxavail" %in% names(day) && "maxavail" %in% names(per)) {
    names(day)[names(day) == "maxavail"] <- "maxavail_day"
  }

  joined <- merge(per, day,
                   by = intersect(c("duid", "bidtype", "trading_day"),
                                  intersect(names(per), names(day))),
                   all.x = TRUE, sort = FALSE)
  rownames(joined) <- NULL
  new_aemo_tbl(joined,
               source = "http://nemweb.com.au",
               title = "AEMO bids (joined: BIDDAYOFFER + BIDPEROFFER)")
}
