# aemo_tbl S3 class

#' @noRd
new_aemo_tbl <- function(df, source = NULL,
                          licence = "AEMO Copyright Permissions Notice",
                          retrieved = Sys.time(), title = NULL) {
  stopifnot(is.data.frame(df))
  attr(df, "aemo_source") <- source
  attr(df, "aemo_licence") <- licence
  attr(df, "aemo_retrieved") <- retrieved
  attr(df, "aemo_title") <- title
  class(df) <- c("aemo_tbl", class(df))
  df
}

#' Print an aemo_tbl
#'
#' @param x An `aemo_tbl`.
#' @param ... Passed to the next print method.
#' @return Invisibly returns `x`.
#' @export
#' @examples
#' x <- data.frame(settlementdate = Sys.time(), region = "NSW1", rrp = 80)
#' x <- structure(x, aemo_title = "Demo", aemo_source = "http://nemweb.com.au",
#'                aemo_licence = "AEMO Copyright Permissions Notice",
#'                aemo_retrieved = Sys.time(),
#'                class = c("aemo_tbl", "data.frame"))
#' print(x)
print.aemo_tbl <- function(x, ...) {
  title <- attr(x, "aemo_title") %||% "AEMO data"
  source <- attr(x, "aemo_source") %||% "http://nemweb.com.au"
  licence <- attr(x, "aemo_licence") %||% "AEMO Copyright Permissions Notice"
  retrieved <- attr(x, "aemo_retrieved")
  retrieved_str <- if (!is.null(retrieved)) {
    format(retrieved, "%Y-%m-%d %H:%M %Z")
  } else {
    "-"
  }

  cat("# aemo_tbl: ", title, "\n", sep = "")
  cat("# Source:   ", source, "\n", sep = "")
  cat("# Licence:  ", licence, "\n", sep = "")
  cat("# Retrieved:", retrieved_str, "\n")
  cat("# Rows: ", formatC(nrow(x), big.mark = ",", format = "d"),
      "  Cols: ", ncol(x), "\n", sep = "")
  cat("\n")

  y <- x
  class(y) <- setdiff(class(y), "aemo_tbl")
  print(y, ...)
  invisible(x)
}
