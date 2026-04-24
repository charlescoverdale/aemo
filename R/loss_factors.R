# Marginal and distribution loss factors

# 5MS commenced 1 October 2021
FIVE_MS_DATE <- as.Date("2021-10-01")

#' Marginal Loss Factors (MLF) by DUID and financial year
#'
#' Returns the Marginal Loss Factor applicable to each DUID for
#' the requested financial year(s). MLFs measure the incremental
#' network loss at a connection point relative to the Regional
#' Reference Node (RRN); a DUID with MLF = 0.97 receives 97% of
#' the regional RRP per MWh generated.
#'
#' MLFs are published annually by AEMO under NER 3.6.2 and are
#' used in settlement calculations and in PPA revenue
#' reconstruction. The function first attempts to download the
#' `TRANSMISSIONLOSSFACTOR` table from the most recent MMSDM monthly
#' archive; if that fails it returns a bundled static table
#' covering FY 2020-21 to FY 2025-26 for ~20 well-known DUIDs.
#'
#' @param year Financial year(s) as `"YYYY-YY"` strings (e.g.
#'   `"2024-25"`). `NULL` returns all available years. Multiple
#'   years accepted.
#' @param duid Optional character vector of DUIDs to filter on.
#'   `NULL` returns all DUIDs. See [aemo_units()] for the full
#'   DUID registry.
#'
#' @return An `aemo_tbl` with columns `financial_year`, `duid`,
#'   `connectionpointid`, `regionid`, `mlf`. From a live MMSDM
#'   download additional columns (`participantid`,
#'   `lastchanged`) may also be present.
#'
#' @source AEMO MMSDM archive, TRANSMISSIONLOSSFACTOR table.
#'   AEMO Copyright Permissions Notice.
#'
#' @seealso [aemo_units()] for the DUID registry,
#'   [aemo_price()] for regional RRPs.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   mlf <- aemo_mlf(year = "2024-25")
#'   head(mlf)
#' })
#' options(op)
#' }
aemo_mlf <- function(year = NULL, duid = NULL) {
  df <- tryCatch(aemo_fetch_mlf_mmsdm(),
                 error = function(e) NULL)

  if (is.null(df) || nrow(df) < 20L) {
    cli::cli_abort(c(
      "Could not retrieve TRANSMISSIONLOSSFACTOR from MMSDM.",
      "i" = "MLFs are published annually by AEMO under NER 3.6.2. For historical analysis, download the determination PDF directly from aemo.com.au, or retry when the MMSDM archive is reachable.",
      "i" = "No fallback is provided: unsourced MLF values would be a correctness trap in settlement and PPA workflows."
    ))
  }

  if (!is.null(year)) {
    if ("financial_year" %in% names(df)) {
      df <- df[df$financial_year %in% year, , drop = FALSE]
    }
    if (nrow(df) == 0L) {
      cli::cli_abort(c(
        "No MLF data found for year{?s}: {.val {year}}.",
        "i" = "Available format: {.val {\"2024-25\"}}."
      ))
    }
  }
  if (!is.null(duid) && "duid" %in% names(df)) {
    df <- df[toupper(df$duid) %in% toupper(duid), , drop = FALSE]
    rownames(df) <- NULL
  }

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM Marginal Loss Factors (MLF)")
}

#' Distribution Loss Factors (DLF) by connection point
#'
#' Returns the Distribution Loss Factor for NEM connection
#' points from the MMSDM `LOSSFACTORMODEL` table. DLFs measure
#' the average energy loss on the distribution network between
#' a connection point and the transmission network boundary; a
#' DLF of 1.02 means the generator must produce 2% more energy
#' than it delivers to the transmission system.
#'
#' DLFs are published annually by AEMO (NER 3.6.3) and combined
#' with MLFs in settlement to give the total loss factor (TLF =
#' MLF x DLF) used in energy payments.
#'
#' @param year Financial year(s) as `"YYYY-YY"`. `NULL` returns
#'   all available years.
#' @param connection_point_id Optional character vector of
#'   connection point IDs.
#'
#' @return An `aemo_tbl` with at minimum `financial_year`,
#'   `connectionpointid`, and `dlf`.
#'
#' @source AEMO MMSDM archive, LOSSFACTORMODEL table.
#'   AEMO Copyright Permissions Notice.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   dlf <- aemo_dlf(year = "2024-25")
#'   head(dlf)
#' })
#' options(op)
#' }
aemo_dlf <- function(year = NULL, connection_point_id = NULL) {
  df <- tryCatch(aemo_fetch_dlf_mmsdm(),
                 error = function(e) NULL)

  if (is.null(df) || nrow(df) < 5L) {
    cli::cli_warn(c(
      "Could not reach MMSDM LOSSFACTORMODEL; returning empty table.",
      "i" = "Use {.fn aemo_nemweb_download} with an MMSDM URL to fetch DLF data directly."
    ))
    df <- data.frame(
      financial_year = character(0L),
      connectionpointid = character(0L),
      dlf = numeric(0L),
      stringsAsFactors = FALSE
    )
  }

  if (!is.null(year) && "financial_year" %in% names(df)) {
    df <- df[df$financial_year %in% year, , drop = FALSE]
  }
  if (!is.null(connection_point_id) && "connectionpointid" %in% names(df)) {
    df <- df[toupper(df$connectionpointid) %in%
               toupper(connection_point_id), , drop = FALSE]
    rownames(df) <- NULL
  }

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM Distribution Loss Factors (DLF)")
}

#' Fetch TRANSMISSIONLOSSFACTOR (MLF) from MMSDM archive.
#'
#' AEMO's MMSDM uses TRANSMISSIONLOSSFACTOR for marginal loss
#' factors, not TRANSMISSIONLOSSFACTOR (which does not exist in the
#' archive). The column is `transmissionlossfactor`.
#' @noRd
aemo_fetch_mlf_mmsdm <- function(max_months_back = 6L) {
  df <- aemo_fetch_mmsdm_table("TRANSMISSIONLOSSFACTOR", min_rows = 1L,
                                max_months_back = max_months_back)
  if (!is.null(df) && "effectivedate" %in% names(df)) {
    df$financial_year <- aemo_fy_label(df$effectivedate)
  }
  if (!is.null(df)) {
    names(df)[names(df) == "transmissionlossfactor"] <- "mlf"
  }
  df
}

#' Fetch LOSSFACTORMODEL (DLF) from MMSDM archive.
#' @noRd
aemo_fetch_dlf_mmsdm <- function(max_months_back = 6L) {
  df <- aemo_fetch_mmsdm_table("LOSSFACTORMODEL", min_rows = 1L,
                                max_months_back = max_months_back)
  if (is.null(df)) return(NULL)
  if ("effectivedate" %in% names(df)) {
    df$financial_year <- aemo_fy_label(df$effectivedate)
  }
  names(df)[names(df) == "distributionlossfactor"] <- "dlf"
  df
}

#' Convert a date (or POSIXct) to a NEM financial-year label.
#'
#' The NEM financial year runs 1 July to 30 June. A date in
#' January 2025 is FY "2024-25"; a date in August 2025 is
#' FY "2025-26".
#' @noRd
aemo_fy_label <- function(x) {
  d <- if (inherits(x, "POSIXct")) as.Date(x, tz = AEMO_TIMEZONE) else as.Date(x)
  yr <- as.integer(format(d, "%Y"))
  mo <- as.integer(format(d, "%m"))
  start_yr <- ifelse(mo >= 7L, yr, yr - 1L)
  end_yy <- sprintf("%02d", (start_yr + 1L) %% 100L)
  paste0(start_yr, "-", end_yy)
}

