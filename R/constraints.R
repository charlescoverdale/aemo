# Binding constraints (DISPATCHCONSTRAINT) and constraint equations (GENCONDATA)

#' Binding transmission and system constraints
#'
#' Returns the `DISPATCHCONSTRAINT` table from NEMweb: one row
#' per binding (or near-binding) constraint per 5-minute dispatch
#' interval. Each row records the constraint ID, the left-hand
#' side (LHS) and right-hand side (RHS) values, the marginal
#' value (shadow price on the constraint in AUD/MWh), and the
#' violation degree if any.
#'
#' This is the table that answers the question "why was the RRP
#' so high at 17:35?": the sum of marginal values across
#' binding constraints at the Regional Reference Node equals the
#' regional price component attributable to network limits.
#'
#' Constraint equations and RHS terms (`GENCONDATA`,
#' `GENCONSETINVOKE`) are published through MMSDM on a separate
#' cadence and are not exposed directly by this function; use
#' [aemo_nemweb_download()] on an MMSDM URL for those.
#'
#' @param start,end Window (inclusive), character or POSIXct.
#' @param constraint_id Optional character vector of constraint
#'   IDs (e.g. `"N>>N-NIL_1"`, `"V::S_NIL_TBSE"`). `NULL`
#'   returns all binding constraints in the window.
#' @param intervention Logical. Default `FALSE`.
#' @param min_marginal_value Numeric. Only return constraints
#'   with marginal value at or above this threshold (AUD/MWh).
#'   `0` returns every row; the default of `0.01` filters out
#'   near-zero shadow prices that are typically noise.
#'
#' @return An `aemo_tbl` with columns `settlementdate`,
#'   `constraintid`, `rhs`, `marginalvalue`, `violationdegree`,
#'   `lhs`, plus the intervention flag.
#'
#' @source AEMO NEMweb DISPATCHIS_Reports, DISPATCHCONSTRAINT
#'   table.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   now <- Sys.time()
#'   c <- aemo_constraints(start = now - 3600, end = now)
#'   head(c)
#' })
#' options(op)
#' }
aemo_constraints <- function(start, end, constraint_id = NULL,
                              intervention = FALSE,
                              min_marginal_value = 0.01) {
  start <- aemo_parse_time(start)
  end <- aemo_parse_time(end)
  stopifnot(end >= start)

  df <- aemo_fetch_report_range(
    current_dir = "/Reports/Current/DispatchIS_Reports/",
    archive_dir = "/Reports/Archive/DispatchIS_Reports/",
    pattern = "DISPATCHIS",
    start = start, end = end,
    table = "dispatch_constraint"
  )
  df <- aemo_coerce_types(df)
  df <- aemo_apply_filters(df, start = start, end = end,
                           intervention = intervention)

  if (!is.null(constraint_id) && "constraintid" %in% names(df)) {
    df <- df[df$constraintid %in% constraint_id, , drop = FALSE]
  }
  if (!is.null(min_marginal_value) && "marginalvalue" %in% names(df)) {
    mv <- suppressWarnings(as.numeric(df$marginalvalue))
    df <- df[!is.na(mv) & abs(mv) >= min_marginal_value, , drop = FALSE]
  }
  rownames(df) <- NULL
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "AEMO dispatch constraints (shadow prices)")
}

#' Generic constraint equations and RHS terms (GENCONDATA)
#'
#' Downloads the `GENCONDATA` table from the most recent MMSDM
#' monthly archive. `GENCONDATA` contains the equation
#' definitions for every generic constraint active in the NEM:
#' the constraint ID, the type (equality/inequality), a
#' description of what the constraint models (thermal limit,
#' voltage stability, system strength, etc.), and the default
#' RHS value.
#'
#' Pair this with [aemo_constraints()] to go from a binding
#' dispatch interval to the underlying network equation. The
#' workflow is: `aemo_constraints()` tells you *which* constraint
#' bound and *how hard* (marginalvalue = shadow price);
#' `aemo_gencon()` tells you *what the constraint is* (which
#' elements and why the RHS was set at that level).
#'
#' @param constraint_id Optional character vector of constraint
#'   IDs to filter on. `NULL` returns all equations.
#' @param type Optional constraint type filter (e.g.
#'   `"LE"` for `<=`, `"GE"` for `>=`, `"EQ"` for `=`).
#'   `NULL` returns all types.
#'
#' @return An `aemo_tbl` with columns including `genconid`
#'   (constraint ID), `constrainttype`, `description`,
#'   `genericconstraintrhs` (default RHS value). Additional
#'   columns from GENCONDATA (effective dates, generic
#'   constraint equation weights) will be present when
#'   available.
#'
#' @source AEMO NEMweb MMSDM archive, GENCONDATA table.
#'   AEMO Copyright Permissions Notice.
#'
#' @seealso [aemo_constraints()] for the real-time binding
#'   constraint shadow prices.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   # Find equations for the Heywood interconnector thermal limits
#'   g <- aemo_gencon(constraint_id = c("V::S_NIL_TBSE", "V::S_NIL_FCSPS"))
#'   head(g)
#' })
#' options(op)
#' }
aemo_gencon <- function(constraint_id = NULL, type = NULL) {
  df <- tryCatch(aemo_fetch_gencondata(),
                 error = function(e) NULL)

  if (is.null(df) || nrow(df) == 0L) {
    cli::cli_abort(c(
      "Could not retrieve GENCONDATA from MMSDM.",
      "i" = "Check your internet connection or use {.fn aemo_nemweb_download} with an MMSDM URL directly.",
      "i" = "MMSDM path: DATA/Archive/Wholesale_Electricity/MMSDM/<YYYY>/<month>/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_GENCONDATA_<YYYYMM>010000.zip"
    ))
  }

  if (!is.null(constraint_id)) {
    id_col <- intersect(c("genconid", "constraintid"), names(df))[1L]
    if (!is.na(id_col)) {
      df <- df[df[[id_col]] %in% constraint_id, , drop = FALSE]
    }
  }
  if (!is.null(type) && "constrainttype" %in% names(df)) {
    df <- df[toupper(df$constrainttype) %in% toupper(type), , drop = FALSE]
  }
  rownames(df) <- NULL

  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM generic constraint equations (GENCONDATA)")
}

#' Fetch GENCONDATA from the most recent MMSDM archive.
#' @noRd
aemo_fetch_gencondata <- function(max_months_back = 6L) {
  aemo_fetch_mmsdm_table("GENCONDATA", min_rows = 1L,
                          max_months_back = max_months_back)
}

#' SPD constraint tables (regions, interconnectors, connection points)
#'
#' Returns the SPD (Security and Projected Dispatch) constraint
#' coefficient tables from MMSDM. Where `GENCONDATA` gives the
#' high-level equation definition, the SPD tables give the
#' per-term *coefficients* used in the NEMDE dispatch
#' optimisation:
#'
#' - `"region"`: `SPDREGIONCONSTRAINT` (regional-demand and
#'   regional-generation terms).
#' - `"interconnector"`: `SPDINTERCONNECTORCONSTRAINT`
#'   (interconnector-flow terms).
#' - `"connection_point"`: `SPDCONNECTIONPOINTCONSTRAINT`
#'   (per-DUID connection-point terms).
#'
#' These tables are required for NEM dispatch replication (the
#' `nempy` Python package, Gorman, Bruce & MacGill 2022,
#' *JOSS* 7(70) 3596, <doi:10.21105/joss.03596>, uses all three
#' when reproducing NEMDE solves).
#'
#' @param table One of `"region"` (default), `"interconnector"`,
#'   or `"connection_point"`.
#' @param constraint_id Optional character vector of
#'   `GENCONID`/`CONSTRAINTID` values.
#'
#' @return An `aemo_tbl` with columns from the requested SPD
#'   table. `GENCONID` and `FACTOR` (the coefficient) are
#'   always present; other columns vary by table.
#'
#' @source AEMO NEMweb MMSDM archive, SPDREGIONCONSTRAINT /
#'   SPDINTERCONNECTORCONSTRAINT / SPDCONNECTIONPOINTCONSTRAINT.
#'
#' @seealso [aemo_gencon()] for the equation-level metadata,
#'   [aemo_constraints()] for the 5-min binding-constraint
#'   feed with shadow prices.
#'
#' @family dispatch
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   s <- aemo_spd_constraints(table = "interconnector")
#'   head(s)
#' })
#' options(op)
#' }
aemo_spd_constraints <- function(table = c("region", "interconnector",
                                            "connection_point"),
                                  constraint_id = NULL) {
  table <- match.arg(table)
  mmsdm_table <- switch(table,
    region            = "SPDREGIONCONSTRAINT",
    interconnector    = "SPDINTERCONNECTORCONSTRAINT",
    connection_point  = "SPDCONNECTIONPOINTCONSTRAINT"
  )

  df <- tryCatch(
    aemo_fetch_mmsdm_table(mmsdm_table, min_rows = 1L),
    error = function(e) NULL
  )
  if (is.null(df) || nrow(df) == 0L) {
    cli::cli_abort(c(
      "Could not retrieve {mmsdm_table} from MMSDM.",
      "i" = "Try {.fn aemo_nemweb_download} with an MMSDM URL directly."
    ))
  }

  if (!is.null(constraint_id)) {
    id_col <- intersect(c("genconid", "constraintid"), names(df))[1L]
    if (!is.na(id_col)) {
      df <- df[df[[id_col]] %in% constraint_id, , drop = FALSE]
      rownames(df) <- NULL
    }
  }
  new_aemo_tbl(df,
               source = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM",
               licence = "AEMO Copyright Permissions Notice",
               title = paste0("NEM ", mmsdm_table,
                              " (SPD constraint coefficients)"))
}
