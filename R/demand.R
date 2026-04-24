#' Regional electricity demand
#'
#' Returns 5-minute regional demand from `DISPATCHREGIONSUM`.
#' Three demand measures are supported, aligned with AEMO's
#' Demand Terms taxonomy:
#'
#' - `"operational"` (default): `TOTALDEMAND`, the grid-measured
#'   demand met by scheduled and semi-scheduled generation plus
#'   net interchange. This is the quantity AEMO dispatches.
#' - `"operational_less_snsg"`: `TOTALDEMAND` minus small
#'   non-scheduled generation (SS_SOLAR_UIGF + SS_WIND_UIGF
#'   where present).
#' - `"native"`: `TOTALDEMAND` plus estimated rooftop PV
#'   generation. Closest to end-use consumption. If the rooftop
#'   PV component is not available in DISPATCHREGIONSUM the
#'   function warns and returns `TOTALDEMAND`; users should join
#'   with `aemo_rooftop_pv()` for a full native-demand estimate.
#'
#' Timestamps are AEST (UTC+10, no DST).
#'
#' @param region NEM region code. Vector accepted.
#' @param start,end Window (inclusive), character or POSIXct.
#' @param measure One of `"operational"` (default),
#'   `"operational_less_snsg"`, or `"native"`.
#' @param intervention Logical. Default `FALSE` filters to market
#'   pricing runs.
#'
#' @return An `aemo_tbl` with columns `settlementdate`,
#'   `regionid`, `demand_mw` (the requested measure), plus the
#'   underlying DISPATCHREGIONSUM columns used in the derivation.
#'
#' @source AEMO NEMweb, AEMO Copyright Permissions Notice.
#'
#' @family demand
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   d <- aemo_demand("VIC1", now - 3600, now)
#'   head(d)
#' })
#' options(op)
#' }
aemo_demand <- function(region, start, end,
                         measure = c("operational",
                                     "operational_less_snsg",
                                     "native"),
                         intervention = FALSE) {
  region <- aemo_validate_region(region)
  measure <- match.arg(measure)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  df <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/DispatchIS_Reports/",
    archive_dir = "/Reports/Archive/DispatchIS_Reports/",
    pattern = "DISPATCHIS",
    start = start, end = end,
    table = "dispatch_regionsum"
  )
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end,
                           region = region, intervention = intervention)

  if ("totaldemand" %in% names(df)) {
    td <- df$totaldemand
    snsg <- rep(0, nrow(df))
    for (col in c("ss_solar_uigf", "ss_wind_uigf")) {
      if (col %in% names(df)) {
        v <- suppressWarnings(as.numeric(df[[col]]))
        v[is.na(v)] <- 0
        snsg <- snsg + v
      }
    }
    roof <- rep(0, nrow(df))
    for (col in c("rooftop_pv", "rooftop_solar")) {
      if (col %in% names(df)) {
        v <- suppressWarnings(as.numeric(df[[col]]))
        v[is.na(v)] <- 0
        roof <- roof + v
      }
    }
    df$demand_mw <- switch(measure,
      operational            = td,
      operational_less_snsg  = td - snsg,
      native                 = td + roof
    )
    if (measure == "native" && all(roof == 0)) {
      cli::cli_warn(c(
        "No rooftop-PV column found in DISPATCHREGIONSUM.",
        "i" = "Native demand returned as TOTALDEMAND only; join {.fn aemo_rooftop_pv} for a full estimate."
      ))
    }
  }

  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = paste0("AEMO demand ", paste(region, collapse = "+"),
                              " (", measure, ")"))
}
