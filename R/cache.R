# Cache management

#' @noRd
aemo_cache_dir <- function() {
  d <- getOption("aemo.cache_dir",
                 default = tools::R_user_dir("aemo", "cache"))
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
  d
}

#' Clear the aemo cache
#'
#' @return Invisibly returns `NULL`.
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' aemo_clear_cache()
#' options(op)
#' }
aemo_clear_cache <- function() {
  d <- aemo_cache_dir()
  files <- list.files(d, full.names = TRUE)
  n <- length(files)
  if (n > 0L) unlink(files, recursive = TRUE)
  cli::cli_inform("Removed {n} cached file{?s} from {.path {d}}.")
  invisible(NULL)
}

#' Inspect the local aemo cache
#'
#' @return A list with `dir`, `n_files`, `size_bytes`, `size_human`, `files`.
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' aemo_cache_info()
#' options(op)
#' }
aemo_cache_info <- function() {
  d <- aemo_cache_dir()
  empty <- data.frame(name = character(0L), size_bytes = numeric(0L),
                      modified = as.POSIXct(character(0L)),
                      stringsAsFactors = FALSE)
  paths <- list.files(d, full.names = TRUE)
  if (length(paths) == 0L) {
    return(list(dir = d, n_files = 0L, size_bytes = 0,
                size_human = "0 B", files = empty))
  }
  info <- file.info(paths)
  files <- data.frame(name = basename(paths),
                      size_bytes = info$size,
                      modified = info$mtime,
                      stringsAsFactors = FALSE)
  files <- files[order(-files$size_bytes), , drop = FALSE]
  rownames(files) <- NULL
  total <- sum(files$size_bytes)
  list(dir = d, n_files = nrow(files), size_bytes = total,
       size_human = aemo_format_bytes(total), files = files)
}

#' Configure request throttling
#'
#' Controls the delay between successive NEMweb requests.
#' Defaults to 1 second (half a request per second).
#'
#' @param delay Numeric. Minimum delay between requests in
#'   seconds. Internally this becomes `httr2::req_throttle(rate = 1/delay)`.
#' @return Invisibly returns the previous value.
#' @family configuration
#' @export
#' @examples
#' old <- aemo_throttle(0.5)  # 2 requests per second
#' aemo_throttle(old)         # restore
aemo_throttle <- function(delay = 1) {
  stopifnot(is.numeric(delay), length(delay) == 1L, delay > 0)
  old <- getOption("aemo.throttle_delay", 1)
  options(aemo.throttle_delay = delay)
  invisible(old)
}
