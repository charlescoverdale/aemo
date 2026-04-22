# Low-level NEMweb access

#' List files in a NEMweb directory
#'
#' Returns a data frame of files in a NEMweb path, parsed from
#' the Apache directory-listing HTML.
#'
#' @param path NEMweb subpath (e.g. `"/Reports/Current/DispatchIS_Reports/"`).
#'   Leading and trailing slashes are optional.
#'
#' @return A data frame with `name`, `modified`, `size`, `url`.
#'
#' @source AEMO NEMweb <http://nemweb.com.au>, published under
#'   the AEMO Copyright Permissions Notice.
#'
#' @family low-level
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
#'   head(files)
#' })
#' options(op)
#' }
aemo_nemweb_ls <- function(path) {
  path <- gsub("^/?", "/", path)
  path <- gsub("/?$", "/", path)
  url <- paste0(aemo_base_url(), path)

  resp <- aemo_request(url, timeout = 60) |>
    httr2::req_perform()
  if (httr2::resp_status(resp) != 200L) {
    cli::cli_abort("NEMweb returned HTTP {httr2::resp_status(resp)} for {.url {url}}.")
  }
  html <- httr2::resp_body_string(resp)

  rx <- "<a href=\"([^\"/]+)\">[^<]+</a>\\s*</td><td[^>]*>([^<]+)</td><td[^>]*>([^<]+)</td>"
  m <- regmatches(html, gregexpr(rx, html))[[1]]
  if (length(m) == 0L) {
    return(data.frame(name = character(0), modified = character(0),
                      size = character(0), url = character(0),
                      stringsAsFactors = FALSE))
  }
  parts <- regmatches(m, regexec(rx, m))
  names_v <- vapply(parts, function(x) x[2], character(1))
  mod_v <- trimws(vapply(parts, function(x) x[3], character(1)))
  size_v <- trimws(vapply(parts, function(x) x[4], character(1)))

  data.frame(
    name = names_v,
    modified = mod_v,
    size = size_v,
    url = paste0(url, names_v),
    stringsAsFactors = FALSE
  )
}

#' Download a NEMweb zipped CSV to the local cache
#'
#' Thin wrapper over the internal cache-aware downloader.
#'
#' @param url A fully-qualified NEMweb URL (zipped CSV).
#' @param cache Logical. Reuse cached file if present.
#'
#' @return Path to the cached file.
#'
#' @family low-level
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
#'   if (nrow(files) > 0) {
#'     f <- aemo_nemweb_download(files$url[1])
#'     file.exists(f)
#'   }
#' })
#' options(op)
#' }
aemo_nemweb_download <- function(url, cache = TRUE) {
  aemo_download_cached(url, cache = cache)
}
