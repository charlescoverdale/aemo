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
#' reconstruction. Each year's determination is read from the
#' `TRANSMISSIONLOSSFACTOR` table of the June MMSDM archive that
#' precedes it, together with the revisions in the monthly archives
#' after it. There is no bundled fallback: if MMSDM cannot be reached
#' the function errors rather than return unsourced values.
#'
#' @param year Financial year(s) as `"YYYY-YY"` strings (e.g.
#'   `"2025-26"`). `NULL` (the default) returns the current
#'   financial year. Multiple years accepted; each needs up to 13
#'   small downloads.
#' @param duid Optional character vector of DUIDs to filter on.
#'   MMSDM publishes MLFs by connection point, so DUIDs are mapped
#'   to connection points through the unit registry ([aemo_units()]),
#'   which adds a `duid` column. `NULL` returns every connection
#'   point.
#'
#' @return An `aemo_tbl` with one row per connection point and
#'   effective date: `financial_year`, `connectionpointid`,
#'   `regionid`, `mlf`, `effectivedate`, `versionno`,
#'   `secondary_tlf` and `lastchanged`, plus `duid` when `duid` is
#'   given. A factor revised during the year appears once per
#'   effective date.
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
  if (is.null(year)) year <- aemo_fy_label(Sys.Date())
  if (!is.character(year) || !all(grepl("^[0-9]{4}-[0-9]{2}$", year))) {
    cli::cli_abort("{.arg year} must be financial years like {.val 2025-26}.")
  }
  df <- tryCatch(aemo_fetch_mlf_mmsdm(year), error = function(e) NULL)

  if (is.null(df) || nrow(df) < 20L) {
    cli::cli_abort(c(
      "Could not retrieve TRANSMISSIONLOSSFACTOR for {.val {year}} from MMSDM.",
      "i" = "Each year's MLFs are published in the June MMSDM archive before it. For years MMSDM no longer holds, download the determination PDF from aemo.com.au.",
      "i" = "No fallback is provided: unsourced MLF values would be a correctness trap in settlement and PPA workflows."
    ))
  }

  if (!is.null(duid)) {
    units <- as.data.frame(aemo_units())
    units <- units[toupper(units$duid) %in% toupper(duid) &
                     !is.na(units$connectionpointid), c("duid", "connectionpointid")]
    units <- units[!duplicated(units), , drop = FALSE]
    df <- merge(units, df, by = "connectionpointid")
    if (nrow(df) == 0L) {
      cli::cli_warn("No MLF rows for DUID{?s} {.val {duid}} in {.val {year}}.")
    }
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

#' Fetch TRANSMISSIONLOSSFACTOR (MLF) for financial years from MMSDM.
#'
#' The full MLF determination for financial year Y-(Y+1) is published in
#' the June Y MMSDM archive, effective 1 July; each later monthly archive
#' carries only that month's revisions, often three or four rows. Taking
#' the newest monthly file, as this used to, therefore found a few rows,
#' fell below the 20-row floor and reported MMSDM as unreachable in every
#' month but July. Each requested year is built from its June file and
#' the monthly files after it, keeping the latest version of each
#' connection point's factor for each effective date.
#' @noRd
aemo_fetch_mlf_mmsdm <- function(years) {
  now <- as.Date(Sys.time(), tz = AEMO_TIMEZONE)
  parts <- list()
  for (fy in years) {
    y <- as.integer(substr(fy, 1L, 4L))
    months <- seq(as.Date(sprintf("%d-06-01", y)),
                  as.Date(sprintf("%d-06-01", y + 1L)), by = "month")
    months <- months[months <= now]
    for (k in seq_along(months)) {
      m <- months[k]
      df <- tryCatch(
        aemo_mmsdm_month("TRANSMISSIONLOSSFACTOR", format(m, "%Y"), format(m, "%m")),
        error = function(e) NULL
      )
      if (!is.null(df) && nrow(df) > 0L) parts[[length(parts) + 1L]] <- df
    }
  }
  if (length(parts) == 0L) return(NULL)
  df <- aemo_coerce_types(do.call(rbind, parts))
  names(df)[names(df) == "transmissionlossfactor"] <- "mlf"
  df$mlf <- suppressWarnings(as.numeric(df$mlf))
  df$financial_year <- aemo_fy_label(df$effectivedate)
  df <- df[df$financial_year %in% years, , drop = FALSE]
  # Latest version of each factor: highest versionno, then lastchanged
  ord <- order(df$connectionpointid, df$effectivedate,
               -suppressWarnings(as.numeric(df$versionno)), df$lastchanged,
               decreasing = c(FALSE, FALSE, FALSE, TRUE), method = "radix")
  df <- df[ord, , drop = FALSE]
  df <- df[!duplicated(df[, c("connectionpointid", "effectivedate")]), , drop = FALSE]
  rownames(df) <- NULL
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

