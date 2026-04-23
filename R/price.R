# Price functions

# 5-minute settlement commenced 1 October 2021 (NER cl. 3.15.1A).
# Before this date 30-min prices came from TRADINGPRICE (TRADINGIS).
# After this date TRADINGIS is still published but the authoritative
# 30-min price for post-5MS periods is the arithmetic mean of the
# six 5-min dispatch prices within each trading interval.
FIVE_MS_START <- as.POSIXct("2021-10-01 00:00:00", tz = "Australia/Brisbane")

#' Wholesale electricity prices
#'
#' Returns 5-minute dispatch prices or 30-minute trading prices
#' for a NEM region over a specified window. Filters intervention
#' runs by default so the returned prices are the market clearing
#' prices used in settlement.
#'
#' **Timestamps** are AEST (UTC+10, no daylight savings) to match
#' AEMO's market clock. See the package-level documentation for
#' the period-ending timestamp convention (a row stamped 00:05 is
#' the 5-minute period ending at 00:05).
#'
#' **Intervention.** `DISPATCHPRICE` contains both market pricing
#' runs (`INTERVENTION = 0`) and physical / intervention runs
#' (`INTERVENTION = 1`). The default filters to market runs.
#' Pass `intervention = TRUE` to get both.
#'
#' **30-minute settlement and the 5MS transition.** Before
#' 1 October 2021 the NEM settled on 30-minute trading prices
#' from `TRADINGPRICE` (TRADINGIS). On 1 October 2021 five-minute
#' settlement (5MS) commenced and settlement moved to native
#' 5-minute prices. When `interval = "30min"`:
#' - For the pre-5MS period (`start < 2021-10-01`): prices are
#'   read from TRADINGIS (`TRADINGPRICE`).
#' - For the post-5MS period: prices are derived by taking the
#'   arithmetic mean of the six 5-minute dispatch prices within
#'   each 30-minute trading interval, consistent with how AEMO
#'   calculates the `TRADINGPRICE` column in TradingIS post-5MS.
#'
#' **Data availability.** NEMweb Current-directory files retain
#' the last ~30 days of 5-minute dispatch files. Historical
#' queries use the Archive daily-rollup files automatically; for
#' queries older than the Archive window, use
#' [aemo_nemweb_download()] with an MMSDM URL directly.
#'
#' @param region One of `"NSW1"`, `"QLD1"`, `"SA1"`, `"TAS1"`,
#'   `"VIC1"`. Accepts a vector.
#' @param start,end Start and end times (inclusive). Character
#'   (parsed as AEST) or `POSIXct`.
#' @param interval One of `"5min"` (default) or `"30min"`.
#' @param market One of `"energy"` (default, returns RRP) or
#'   `"fcas"` (returns the FCAS service RRPs).
#' @param intervention Logical. `FALSE` (default) returns only
#'   the market pricing run; `TRUE` returns both market and
#'   physical runs, with the `intervention` column preserved.
#'
#' @return An `aemo_tbl`. Key columns include `settlementdate`
#'   (POSIXct AEST), `regionid`, `rrp` (AUD/MWh, energy) or the
#'   FCAS service RRPs (AUD/MW), and `intervention`.
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
#'   now <- Sys.time()
#'   p <- aemo_price("NSW1", now - 3600, now)
#'   head(p)
#' })
#' options(op)
#' }
aemo_price <- function(region, start, end,
                        interval = c("5min", "30min"),
                        market = c("energy", "fcas"),
                        intervention = FALSE) {
  region <- aemo_validate_region(region)
  interval <- match.arg(interval)
  market <- match.arg(market)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  if (interval == "5min") {
    df <- aemo_fetch_report_range(
      current_dir = "/Reports/Current/DispatchIS_Reports/",
      archive_dir = "/Reports/Archive/DispatchIS_Reports/",
      pattern = "DISPATCHIS",
      start = start, end = end,
      table = "dispatch_price"
    )
    df <- aemo_coerce_types(df)
    df <- aemo_apply_filters(df, start = start, end = end,
                             region = region, intervention = intervention)
  } else {
    df <- aemo_price_30min(region = region, start = start, end = end,
                           intervention = intervention)
  }

  if (market == "fcas") {
    fcas_cols <- grep("(raise|lower).*rrp$", names(df),
                      value = TRUE, ignore.case = TRUE)
    keep <- intersect(
      c("settlementdate", "regionid", "runno", "intervention", fcas_cols),
      names(df)
    )
    df <- df[, keep, drop = FALSE]
  }

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = sprintf("AEMO %s %s price %s",
                                interval, market,
                                paste(region, collapse = "+")))
}

#' Fetch 30-minute prices spanning the 5MS transition boundary.
#'
#' Pre-5MS (before 2021-10-01): TRADINGIS, table `trading_price`.
#' Post-5MS (from 2021-10-01): aggregate 6 x 5-min dispatch prices
#' within each 30-min trading interval (arithmetic mean of RRP).
#' @noRd
aemo_price_30min <- function(region, start, end, intervention) {
  parts <- list()

  # Pre-5MS portion
  if (start < FIVE_MS_START) {
    pre_end <- min(end, FIVE_MS_START - as.difftime(1, units = "secs"))
    df_pre <- tryCatch(
      aemo_fetch_report_range(
        current_dir = "/Reports/Current/TradingIS_Reports/",
        archive_dir = "/Reports/Archive/TradingIS_Reports/",
        pattern = "TRADINGIS",
        start = start, end = pre_end,
        table = "trading_price"
      ),
      error = function(e) NULL
    )
    if (!is.null(df_pre) && nrow(df_pre) > 0L) {
      df_pre <- aemo_coerce_types(df_pre)
      df_pre <- aemo_apply_filters(df_pre, start = start, end = pre_end,
                                   region = region, intervention = intervention)
      if ("tradingdate" %in% names(df_pre) && !"settlementdate" %in% names(df_pre)) {
        names(df_pre)[names(df_pre) == "tradingdate"] <- "settlementdate"
      }
      parts[["pre"]] <- df_pre
    }
  }

  # Post-5MS portion: aggregate 5-min dispatch to 30-min
  if (end >= FIVE_MS_START) {
    post_start <- max(start, FIVE_MS_START)
    df5 <- tryCatch(
      aemo_fetch_report_range(
        current_dir = "/Reports/Current/DispatchIS_Reports/",
        archive_dir = "/Reports/Archive/DispatchIS_Reports/",
        pattern = "DISPATCHIS",
        start = post_start, end = end,
        table = "dispatch_price"
      ),
      error = function(e) NULL
    )
    if (!is.null(df5) && nrow(df5) > 0L) {
      df5 <- aemo_coerce_types(df5)
      df5 <- aemo_apply_filters(df5, start = post_start, end = end,
                                region = region, intervention = intervention)
      df_post <- aemo_aggregate_to_30min(df5)
      if (nrow(df_post) > 0L) parts[["post"]] <- df_post
    }
  }

  if (length(parts) == 0L) {
    cli::cli_abort("No 30-minute price data found for the requested range.")
  }
  if (length(parts) == 1L) return(parts[[1L]])

  common <- Reduce(intersect, lapply(parts, names))
  stacked <- do.call(rbind,
                     lapply(parts, function(d) d[, common, drop = FALSE]))
  rownames(stacked) <- NULL
  stacked
}

#' Aggregate 5-minute dispatch prices to 30-minute trading intervals.
#'
#' The 30-minute trading period ending at time T contains the six
#' 5-minute dispatch intervals ending at T-25, T-20, T-15, T-10,
#' T-5, and T. The representative price is the arithmetic mean
#' of the six RRPs (matching AEMO's post-5MS TRADINGPRICE
#' derivation in TRADINGIS).
#' @noRd
aemo_aggregate_to_30min <- function(df) {
  if (!"settlementdate" %in% names(df)) return(df)
  if (!"rrp" %in% names(df)) return(df)

  ts <- df$settlementdate
  # Trading interval end = ceiling to nearest 30 minutes
  # epoch in seconds mod 1800; shift timestamps to 30-min boundaries
  epoch <- as.numeric(ts)
  ti_end <- as.POSIXct(ceiling(epoch / 1800) * 1800,
                       origin = "1970-01-01", tz = AEMO_TIMEZONE)
  df$.ti_end <- ti_end

  ids <- c("regionid", ".ti_end")
  ids <- intersect(ids, names(df))
  groups <- unique(df[, ids, drop = FALSE])

  out_rows <- vector("list", nrow(groups))
  for (i in seq_len(nrow(groups))) {
    mask <- rep(TRUE, nrow(df))
    for (col in ids) mask <- mask & df[[col]] == groups[i, col]
    sub <- df[mask, , drop = FALSE]
    row <- sub[1L, setdiff(names(sub), c("settlementdate", "rrp", ".ti_end")),
               drop = FALSE]
    row$settlementdate <- groups[i, ".ti_end"]
    row$rrp <- mean(sub$rrp, na.rm = TRUE)
    out_rows[[i]] <- row
  }
  result <- do.call(rbind, out_rows)
  result <- result[, setdiff(names(result), ".ti_end"), drop = FALSE]
  rownames(result) <- NULL
  result[order(result$settlementdate), , drop = FALSE]
}

#' Frequency control ancillary services (FCAS) prices
#'
#' Returns regional FCAS market prices across the eight
#' contingency services plus the two regulation services. Ten
#' services are live in the NEM since R1/L1 Very Fast commenced
#' on 9 October 2023.
#'
#' Thin wrapper over `aemo_price(..., market = "fcas")`.
#'
#' @param region NEM region code.
#' @param start,end Window (inclusive).
#' @param service Optional character vector of service names
#'   (e.g. `"RAISE6SEC"`, `"LOWER60SEC"`, `"RAISE1SEC"`).
#' @param intervention Logical. See [aemo_price()].
#'
#' @return An `aemo_tbl` with one row per interval and columns
#'   for each requested FCAS RRP (AUD/MW).
#'
#' @family price
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   f <- aemo_fcas("NSW1", now - 3600, now)
#'   head(f)
#' })
#' options(op)
#' }
aemo_fcas <- function(region, start, end, service = NULL,
                       intervention = FALSE) {
  df <- aemo_price(region = region, start = start, end = end,
                   interval = "5min", market = "fcas",
                   intervention = intervention)
  if (!is.null(service)) {
    service_cols <- paste0(tolower(service), "rrp")
    keep <- union(c("settlementdate", "regionid", "runno", "intervention"),
                  service_cols)
    df <- df[, intersect(keep, names(df)), drop = FALSE]
  }
  df
}
