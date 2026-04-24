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
  # Pre-2022 values from the AEMC 2018 Reliability Standard & Settings
  # Review (RSSR); 2022-23 onwards from the AEMC's 2022 Reliability
  # Settings Review which materially lifted the CPT after the June 2022
  # NEM suspension. The CPT step-change from AUD 232,900 (2020-21) to
  # AUD 1,359,100 (2021-22 revised / 2022-23) reflects the rule change
  # from "7.5 x weekly CPT base" to the new formula.
  # Per-row source: the row's CPT / MPC / APC comes from the AEMC
  # determination cited in `source_doc`.
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
    source_doc = c(
      "AEMC 2014 RSSR final determination (CPI-indexed annually)",
      "AEMC 2014 RSSR final determination (CPI-indexed annually)",
      "AEMC 2014 RSSR final determination (CPI-indexed annually)",
      "AEMC 2018 RSSR final determination (CPI-indexed annually)",
      "AEMC 2018 RSSR final determination (CPI-indexed annually)",
      "AEMC 2018 RSSR final determination (CPI-indexed annually)",
      "AEMC 2020 RSSR final determination; CPT revised per 2022 review",
      "AEMC 2022 Reliability Settings Review final determination",
      "AEMC 2022 Reliability Settings Review + 2023 CPI indexation",
      "AEMC 2024 Reliability Settings Review final determination",
      "AEMC 2024 Reliability Settings Review + 2025 CPI indexation"
    ),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "https://www.aemc.gov.au/regulation/energy-rules/national-electricity-rules",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM market price caps, floor, CPT, and APC")
}
