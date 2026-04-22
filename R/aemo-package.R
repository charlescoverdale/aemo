#' aemo: Australian Energy Market Operator Data
#'
#' Tidy R access to AEMO's public data: wholesale electricity
#' prices, demand, dispatch, interconnector flows, rooftop PV,
#' bids, predispatch and PASA forecasts, FCAS markets, and gas
#' markets across the NEM.
#'
#' @section Main function families:
#' - [aemo_price()], [aemo_demand()]: workhorse price and demand.
#' - [aemo_dispatch_units()], [aemo_interconnector()],
#'   [aemo_rooftop_pv()]: dispatch and flow.
#' - [aemo_bids()], [aemo_predispatch()], [aemo_pasa()]: bids
#'   and forecasts.
#' - [aemo_fcas()], [aemo_gas()]: ancillary services and gas.
#' - [aemo_units()], [aemo_regions()], [aemo_interconnectors()]:
#'   reference data.
#' - [aemo_nemweb_ls()], [aemo_nemweb_download()]: low-level
#'   escape hatches for arbitrary NEMweb paths.
#' - [aemo_cache_info()], [aemo_clear_cache()], [aemo_throttle()]:
#'   configuration.
#'
#' @section Data source:
#' Data is published by AEMO at <http://nemweb.com.au> under the
#' AEMO Copyright Permissions Notice
#' <https://www.aemo.com.au/privacy-and-legal-notices/copyright-permissions>.
#'
#' @keywords internal
#' @concept AEMO
#' @concept NEM
#' @concept electricity market
#' @concept wholesale electricity
"_PACKAGE"

utils::globalVariables(c("aemo_regions_df", "aemo_interconnectors_df"))
