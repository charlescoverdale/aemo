# Settlement reconciliation (SETCFM, SETFCASREGIONRECOVERY,
# SETRESIDUECONTRACTPAYMENT)

#' Settlement cash-flow and residue tables
#'
#' Returns settlement reconciliation tables from MMSDM. Three
#' views are exposed, corresponding to the three tables gentailer
#' hedging workflows most commonly need:
#'
#' - `"cashflow"` (default): `SETCFM` (NEMDE-derived energy
#'   settlement amounts per participant per trading interval).
#' - `"fcas_recovery"`: `SETFCASREGIONRECOVERY` (the recovery
#'   allocation of FCAS costs to customer load per region per
#'   trading interval).
#' - `"residues"`: `SETRESIDUECONTRACTPAYMENT` (settlement
#'   residue auction (SRA) contract payments against
#'   interconnector settlement residues).
#'
#' **Access.** These tables are in the MMSDM monthly archive
#' (not the NEMweb Current retention). Expect two-month latency
#' between trading date and availability.
#'
#' @param table One of `"cashflow"`, `"fcas_recovery"`, or
#'   `"residues"`.
#' @param start,end Window (inclusive) applied to
#'   `SETTLEMENTDATE` / `PAYMENTDATE`.
#'
#' @return An `aemo_tbl` with the raw MMSDM columns for the
#'   requested table.
#'
#' @source AEMO NEMweb MMSDM archive, SETCFM /
#'   SETFCASREGIONRECOVERY / SETRESIDUECONTRACTPAYMENT.
#'   AEMO Copyright Permissions Notice.
#'
#' @seealso [aemo_mlf()] for the transmission loss factors that
#'   scale settlement amounts; [aemo_interconnector()] for the
#'   flow side of the residue calculation.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   s <- aemo_settlement(table = "cashflow",
#'                         start = "2024-06-01",
#'                         end   = "2024-06-02")
#'   head(s)
#' })
#' options(op)
#' }
aemo_settlement <- function(table = c("cashflow", "fcas_recovery",
                                        "residues"),
                              start, end) {
  table <- match.arg(table)
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  mmsdm_table <- switch(table,
    cashflow       = "SETCFM",
    fcas_recovery  = "SETFCASREGIONRECOVERY",
    residues       = "SETRESIDUECONTRACTPAYMENT"
  )

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
    url <- aemo_mmsdm_url(mmsdm_table, y, m)
    df <- tryCatch({
      zip_path <- aemo_download_cached(url)
      tmp <- tempfile(paste0("aemo_", tolower(table), "_"))
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
      "Could not retrieve {mmsdm_table} from MMSDM.",
      "i" = "Settlement tables are published with ~2 month latency. Check that {.val {min(months_needed)}} is within the published window."
    ))
  }
  common <- Reduce(intersect, lapply(all_parts, names))
  df <- do.call(rbind, lapply(all_parts, function(d) d[, common, drop = FALSE]))
  df <- aemo_coerce_types(df)

  ts_col <- intersect(c("settlementdate", "paymentdate"), names(df))[1L]
  if (!is.na(ts_col)) {
    ts <- if (inherits(df[[ts_col]], "POSIXct")) df[[ts_col]] else
      aemo_parse_col_time(df[[ts_col]])
    keep <- !is.na(ts) & ts >= start & ts <= end
    df <- df[keep, , drop = FALSE]
  }
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = paste0("NEM settlement ", table,
                              " (", mmsdm_table, ")"))
}
