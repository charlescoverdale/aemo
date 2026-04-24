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
      # No sidecar yet — write one so future calls can verify.
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
#' Uses `tools::md5sum()` as a fallback when `openssl` is absent.
#' The digest is used for cache-integrity verification only, not
#' cryptographic security, so MD5 is acceptable if SHA-256 is
#' unavailable.
#' @noRd
aemo_sha256_file <- function(path) {
  if (requireNamespace("openssl", quietly = TRUE)) {
    as.character(openssl::sha256(file(path, "rb")))
  } else {
    # tools::md5sum is always available (base R)
    paste0("md5:", unname(tools::md5sum(path)))
  }
}

#' @noRd
aemo_digest_url <- function(url) {
  chars <- utf8ToInt(url)
  weights <- seq_along(chars)
  checksum <- sum(as.numeric(chars) * weights) %% (2^31 - 1)
  sprintf("%010.0f_%04d", as.numeric(checksum), nchar(url) %% 10000L)
}
