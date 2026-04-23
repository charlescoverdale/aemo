# Binding constraints (DISPATCHCONSTRAINT)

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
#' so high at 17:35?" — the sum of marginal values across
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
