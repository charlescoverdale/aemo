# NEM market price caps, floor, and Cumulative Price Threshold

#' NEM market price caps, price floor, and CPT by financial year
#'
#' Returns a static reference table of the **Market Price Cap
#' (MPC)**, **Market Price Floor (MPF)**, **Cumulative Price
#' Threshold (CPT)**, and **Administered Price Cap (APC)** that
#' apply in each NEM financial year (1 July to 30 June). These
#' are set by the AEMC under NER 3.9.4 and indexed annually to
#' CPI.
#'
#' Use this table to interpret spot-price extremes: any RRP
#' hitting the MPC (typically AUD 15,000 to 17,500 per MWh
#' depending on year) indicates a price cap event; when the
#' rolling-seven-day cumulative price in a region exceeds the
#' CPT (~AUD 1.5 million per MWh-equivalent), AEMO imposes the
#' APC (AUD 300/MWh) until the CPT falls back below the threshold.
#'
#' The table covers 2015-16 onwards and is updated on each
#' package release. For the authoritative current values see
#' <https://www.aemc.gov.au/regulation/energy-rules/national-electricity-rules>
#' and the AEMO Reliability Settings publications.
#'
#' @return An `aemo_tbl` with columns `year` (financial year,
#'   `"YYYY-YY"`), `market_price_cap_aud_per_mwh`,
#'   `market_price_floor_aud_per_mwh`,
#'   `cumulative_price_threshold_aud`,
#'   `administered_price_cap_aud_per_mwh`, and `source`.
#'
#' @family reference
#' @export
#' @examples
#' caps <- aemo_price_caps()
#' head(caps)
aemo_price_caps <- function() {
  df <- data.frame(
    year = c("2015-16", "2016-17", "2017-18", "2018-19",
             "2019-20", "2020-21", "2021-22", "2022-23",
             "2023-24", "2024-25", "2025-26"),
    market_price_cap_aud_per_mwh = c(
      13800, 14000, 14200, 14500,
      14700, 15000, 15100, 15500,
      16600, 17500, 17500
    ),
    market_price_floor_aud_per_mwh = rep(-1000, 11),
    cumulative_price_threshold_aud = c(
      212800, 216500, 219700, 224300,
      228700, 232900, 1359100, 1398100,
      1502100, 1577100, 1626800
    ),
    administered_price_cap_aud_per_mwh = rep(300, 11),
    source = rep("AEMC Reliability Standard & Settings review", 11),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "https://www.aemc.gov.au/regulation/energy-rules/national-electricity-rules",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM market price caps, floor, CPT, and APC")
}
