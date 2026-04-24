# Reproducibility helper: aemo_snapshot()

#' Snapshot provenance for an aemo_tbl
#'
#' Returns a one-row-per-source provenance record for an
#' `aemo_tbl`, suitable for inclusion in a paper appendix, a
#' Zenodo deposit, or a CRAN-style data manifest. The snapshot
#' captures:
#'
#' - `title`: the human-readable title of the table;
#' - `source`: the NEMweb / MMSDM URL family the table was drawn
#'   from;
#' - `licence`: the AEMO Copyright Permissions Notice (always);
#' - `retrieved`: the `POSIXct` timestamp at which the table was
#'   constructed;
#' - `rows`, `cols`: observed dimensions;
#' - `sha256`: a SHA-256 digest of the table's printed body,
#'   stable across R versions and platforms.
#'
#' The `sha256` column is what makes the snapshot *pinnable*: if
#' the same query returns a different hash, the underlying data
#' has changed (or the row-order has, which is also worth
#' knowing). Pair with a git commit of the analysis script to
#' give a reader a closed reproducibility loop.
#'
#' @param x An `aemo_tbl` (or a list of them).
#' @return A data frame with one row per table.
#'
#' @family reference
#' @export
#' @examples
#' x <- structure(
#'   data.frame(settlementdate = Sys.time(), region = "NSW1", rrp = 80),
#'   aemo_title = "Demo",
#'   aemo_source = "http://nemweb.com.au",
#'   aemo_licence = "AEMO Copyright Permissions Notice",
#'   aemo_retrieved = Sys.time(),
#'   class = c("aemo_tbl", "data.frame")
#' )
#' aemo_snapshot(x)
aemo_snapshot <- function(x) {
  if (inherits(x, "aemo_tbl") || is.data.frame(x)) {
    x <- list(x)
  }
  if (!is.list(x) || length(x) == 0L) {
    cli::cli_abort("{.arg x} must be an {.cls aemo_tbl} or a non-empty list of them.")
  }

  rows <- lapply(x, aemo_snapshot_row)
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  out
}

#' @noRd
aemo_snapshot_row <- function(x) {
  if (!is.data.frame(x)) {
    cli::cli_abort("Each element must be a data frame.")
  }
  title <- attr(x, "aemo_title") %||% NA_character_
  src   <- attr(x, "aemo_source") %||% NA_character_
  lic   <- attr(x, "aemo_licence") %||% "AEMO Copyright Permissions Notice"
  retr  <- attr(x, "aemo_retrieved") %||% as.POSIXct(NA)

  # SHA-256 over a canonical serialisation: drop attributes + row names,
  # coerce all columns to character, paste with a sentinel separator.
  body <- x
  attributes(body)[setdiff(names(attributes(body)),
                            c("names", "row.names", "class"))] <- NULL
  class(body) <- "data.frame"
  rownames(body) <- NULL
  flat <- do.call(paste, c(lapply(body, as.character), sep = "\x1f"))
  digest <- as.character(openssl::sha256(charToRaw(paste(flat, collapse = "\n"))))

  data.frame(
    title = title,
    source = src,
    licence = lic,
    retrieved = retr,
    rows = nrow(x),
    cols = ncol(x),
    sha256 = digest,
    stringsAsFactors = FALSE
  )
}
