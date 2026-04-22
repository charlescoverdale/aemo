# Internal helpers

#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

#' @noRd
aemo_format_bytes <- function(x) {
  if (is.na(x) || x < 1024) return(paste0(x, " B"))
  units <- c("KB", "MB", "GB", "TB")
  for (i in seq_along(units)) {
    x <- x / 1024
    if (x < 1024 || i == length(units)) {
      return(sprintf("%.1f %s", x, units[i]))
    }
  }
}

#' @noRd
aemo_clean_names <- function(x) {
  x <- tolower(x)
  x <- gsub("[^a-z0-9]+", "_", x)
  x <- gsub("^_+|_+$", "", x)
  x <- gsub("_+", "_", x)
  x
}

#' Valid NEM region codes
#' @noRd
AEMO_REGIONS <- c("NSW1", "QLD1", "SA1", "TAS1", "VIC1")

#' Validate region against the known NEM set.
#' @noRd
aemo_validate_region <- function(region) {
  region <- toupper(region)
  bad <- setdiff(region, AEMO_REGIONS)
  if (length(bad) > 0L) {
    cli::cli_abort(c(
      "Unknown NEM region{?s}: {.val {bad}}.",
      "i" = "Valid regions: {.val {AEMO_REGIONS}}."
    ))
  }
  region
}

#' Parse a user-supplied timestamp to POSIXct AEST.
#' @noRd
aemo_parse_time <- function(x) {
  if (inherits(x, "POSIXct")) return(x)
  if (inherits(x, "Date")) {
    return(as.POSIXct(paste0(x, " 00:00:00"), tz = "Australia/Sydney"))
  }
  if (is.character(x)) {
    return(as.POSIXct(x, tz = "Australia/Sydney"))
  }
  cli::cli_abort("Could not parse time {.val {x}}.")
}
