# HTTP helpers

#' @noRd
AEMO_BASE_URL <- "http://nemweb.com.au"

#' @noRd
aemo_base_url <- function() {
  getOption("aemo.base_url", default = AEMO_BASE_URL)
}

#' @noRd
aemo_user_agent <- function() {
  paste0("aemo R package/", utils::packageVersion("aemo"),
         " (+https://github.com/charlescoverdale/aemo)")
}

#' @noRd
aemo_request <- function(url, timeout = 180) {
  delay <- getOption("aemo.throttle_delay", 1)
  httr2::request(url) |>
    httr2::req_user_agent(aemo_user_agent()) |>
    httr2::req_throttle(rate = 1 / delay) |>
    httr2::req_timeout(timeout) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_error(is_error = function(r) FALSE)
}

#' @noRd
aemo_download_cached <- function(url, cache = TRUE) {
  d <- aemo_cache_dir()
  ext <- tools::file_ext(url)
  ext <- if (nzchar(ext)) paste0(".", ext) else ""
  slug <- aemo_digest_url(url)
  file <- file.path(d, paste0(slug, ext))
  hash_file <- file.path(d, paste0(slug, ".sha256"))

  if (cache && file.exists(file) && file.size(file) > 0L) {
    # Verify content hash if a sidecar exists; re-download on mismatch.
    if (file.exists(hash_file)) {
      stored <- trimws(readLines(hash_file, warn = FALSE)[1L])
      actual <- aemo_sha256_file(file)
      if (!identical(stored, actual)) {
        cli::cli_warn("Cache integrity check failed for {.file {basename(file)}}; re-downloading.")
        unlink(c(file, hash_file), force = TRUE)
      } else {
        return(file)
      }
    } else {
      # No sidecar yet. Write one so future calls can verify.
      writeLines(aemo_sha256_file(file), hash_file)
      return(file)
    }
  }

  cli::cli_progress_step("Downloading {.url {url}}")

  resp <- tryCatch(
    aemo_request(url) |>
      httr2::req_perform(path = file),
    error = function(e) {
      if (file.exists(file)) unlink(file)
      cli::cli_abort(c("Download failed.", "x" = conditionMessage(e)))
    }
  )

  if (!is.null(resp) && httr2::resp_status(resp) >= 400L) {
    unlink(c(file, hash_file), force = TRUE)
    cli::cli_abort("HTTP {httr2::resp_status(resp)} from {.url {url}}.")
  }

  if (file.exists(file) && file.size(file) > 0L) {
    writeLines(aemo_sha256_file(file), hash_file)
  }
  file
}

#' Compute a SHA-256 hex digest of a file.
#'
#' `openssl` is an Import (see DESCRIPTION), so it is always
#' available. Used for cache-integrity verification, not
#' cryptographic security.
#' @noRd
aemo_sha256_file <- function(path) {
  as.character(openssl::sha256(file(path, "rb")))
}

#' Cache key for a URL.
#'
#' Collision-free: SHA-256 of the URL bytes, truncated to 16
#' hex characters (64 bits). At this width the expected number
#' of collisions across AEMO's entire MMSDM history is
#' effectively zero. v0.1.0 used a bespoke weighted-character
#' checksum with a realistic collision probability on large
#' caches.
#' @noRd
aemo_digest_url <- function(url) {
  substr(as.character(openssl::sha256(charToRaw(url))), 1L, 16L)
}
