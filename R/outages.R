# Network outages (NETWORK_OUTAGEDETAIL)

#' Planned and forced network outages
#'
#' Returns the `NETWORK_OUTAGEDETAIL` table from MMSDM, which
#' records every planned and forced outage on NEM transmission
#' and distribution network elements. Outages are a primary
#' driver of binding constraints and price spikes: when a line
#' or transformer is out of service the network is more
#' constrained, reducing the thermal limits that appear as RHS
#' values in DISPATCHCONSTRAINT.
#'
#' **Use case.** Pair with [aemo_constraints()] to explain a
#' price spike: `aemo_outages()` tells you which elements were
#' off-service at the time; `aemo_constraints()` tells you
#' which constraints bound; together they answer "why was SA
#' spot price AUD 15,000 at 17:35?".
#'
#' @param start,end Outage window (inclusive). Filters on
#'   `starttime` and `endtime`: any outage active during the
#'   window is returned. Character or POSIXct.
#' @param element_id Optional character vector of network
#'   element IDs. `NULL` returns all elements.
#' @param outage_type Optional character. One of `"PLANNED"`,
#'   `"FORCED"`, or `NULL` (both). Case-insensitive.
#' @param region Optional NEM region code. Filters on the
#'   region column where available.
#'
#' @return An `aemo_tbl` with columns from
#'   NETWORK_OUTAGEDETAIL including `outageid`, `starttime`,
#'   `endtime`, `substationid`, `equipmenttype`,
#'   `equipmentid`, `outagetype`, `regionid`, and
#'   `restarttimeunknown`. Exact column set depends on the
#'   MMSDM version.
#'
#' @source AEMO NEMweb MMSDM archive, NETWORK_OUTAGEDETAIL
#'   table. AEMO Copyright Permissions Notice.
#'
#' @seealso [aemo_constraints()] for the binding constraint
#'   shadow prices that these outages drive.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   # Forced outages during a recent high-price period in SA
#'   o <- aemo_outages(
#'     start = "2024-03-01",
#'     end   = "2024-03-02",
#'     outage_type = "FORCED"
#'   )
#'   head(o)
#' })
#' options(op)
#' }
aemo_outages <- function(start, end,
                          element_id = NULL,
                          outage_type = NULL,
                          region = NULL) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)
  if (!is.null(region)) region <- aemo_validate_region(region)
  if (!is.null(outage_type)) {
    outage_type <- toupper(outage_type)
    valid_types <- c("PLANNED", "FORCED")
    bad <- setdiff(outage_type, valid_types)
    if (length(bad) > 0L) {
      cli::cli_abort(c(
        "Unknown outage type{?s}: {.val {bad}}.",
        "i" = "Valid types: {.val {valid_types}}."
      ))
    }
  }

  df <- tryCatch(
    aemo_fetch_outagedetail(start = start, end = end),
    error = function(e) {
      cli::cli_abort(c(
        "Could not retrieve NETWORK_OUTAGEDETAIL from MMSDM.",
        "x" = conditionMessage(e),
        "i" = "Try {.fn aemo_nemweb_download} with an explicit MMSDM URL."
      ))
    }
  )

  if (is.null(df) || nrow(df) == 0L) {
    cli::cli_abort("No outage data found for the requested range.")
  }

  df <- aemo_coerce_types(df)

  # Filter: any outage that overlaps the requested window
  start_col <- intersect(c("starttime", "outagestarttime"), names(df))[1L]
  end_col   <- intersect(c("endtime",   "outageendtime"),   names(df))[1L]
  if (!is.na(start_col) && !is.na(end_col)) {
    s <- if (inherits(df[[start_col]], "POSIXct")) df[[start_col]] else
      aemo_parse_col_time(df[[start_col]])
    e <- if (inherits(df[[end_col]], "POSIXct")) df[[end_col]] else
      aemo_parse_col_time(df[[end_col]])
    # Overlap: outage starts before window end AND ends after window start
    # (or end is NA, meaning the outage is still open)
    keep <- !is.na(s) & s <= end & (is.na(e) | e >= start)
    df <- df[keep, , drop = FALSE]
  }

  if (!is.null(element_id)) {
    id_col <- intersect(c("equipmentid", "elementid"), names(df))[1L]
    if (!is.na(id_col)) {
      df <- df[df[[id_col]] %in% element_id, , drop = FALSE]
    }
  }
  if (!is.null(outage_type) && "outagetype" %in% names(df)) {
    df <- df[toupper(df$outagetype) %in% outage_type, , drop = FALSE]
  }
  if (!is.null(region) && "regionid" %in% names(df)) {
    df <- df[df$regionid %in% region, , drop = FALSE]
  }
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM network outages (NETWORK_OUTAGEDETAIL)")
}

#' Fetch NETWORK_OUTAGEDETAIL from MMSDM for a date range.
#' @noRd
aemo_fetch_outagedetail <- function(start, end, max_months_back = 6L) {
  now <- Sys.time()
  attr(now, "tzone") <- AEMO_TIMEZONE

  # Determine which monthly archives to fetch (one per calendar month in range)
  months_needed <- unique(format(
    seq(as.Date(start, tz = AEMO_TIMEZONE),
        as.Date(end,   tz = AEMO_TIMEZONE),
        by = "month"),
    "%Y-%m"
  ))
  # Also try the most recent archive if range is very recent
  recent <- format(as.Date(now) - 30L, "%Y-%m")
  months_needed <- union(months_needed, recent)

  all_parts <- list()
  for (ym in months_needed) {
    y <- substr(ym, 1L, 4L)
    m <- substr(ym, 6L, 7L)
    url <- aemo_mmsdm_url("NETWORK_OUTAGEDETAIL", y, m)
    df <- tryCatch({
      zip_path <- aemo_download_cached(url)
      tmp <- tempfile("aemo_out_")
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

  if (length(all_parts) == 0L) return(NULL)
  common <- Reduce(intersect, lapply(all_parts, names))
  stacked <- do.call(rbind,
                     lapply(all_parts, function(d) d[, common, drop = FALSE]))
  rownames(stacked) <- NULL
  stacked
}
