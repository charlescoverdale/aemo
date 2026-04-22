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

  # NEMweb uses IIS-style directory listings. Each entry is:
  #   <date> <time> AM/PM <size> <A HREF="/path/FILE.zip">FILE.zip</A><br>
  row_rx <- "(\\w+, \\w+ \\d+, \\d+\\s+\\d+:\\d+\\s+[AP]M)\\s+(\\d+)\\s+<A HREF=\"([^\"]+)\">([^<]+)</A>"
  m <- regmatches(html, gregexpr(row_rx, html, ignore.case = TRUE))[[1]]

  if (length(m) == 0L) {
    # Fallback: grab any file-like <A HREF=...> without date/size.
    # Drop the parent-directory navigation link.
    plain_rx <- "<A HREF=\"([^\"]+)\">([^<]+)</A>"
    m2 <- regmatches(html, gregexpr(plain_rx, html, ignore.case = TRUE))[[1]]
    if (length(m2) == 0L) {
      return(data.frame(name = character(0), modified = character(0),
                        size = character(0), url = character(0),
                        stringsAsFactors = FALSE))
    }
    parts <- regmatches(m2, regexec(plain_rx, m2, ignore.case = TRUE))
    hrefs <- vapply(parts, function(x) x[2], character(1))
    names_v <- vapply(parts, function(x) x[3], character(1))
    keep <- !grepl("parent directory", names_v, ignore.case = TRUE)
    hrefs <- hrefs[keep]; names_v <- names_v[keep]
    urls <- ifelse(grepl("^https?://", hrefs), hrefs,
                   paste0(aemo_base_url(), hrefs))
    return(data.frame(
      name = names_v,
      modified = NA_character_,
      size = NA_character_,
      url = urls,
      stringsAsFactors = FALSE
    ))
  }

  parts <- regmatches(m, regexec(row_rx, m, ignore.case = TRUE))
  mod_v <- vapply(parts, function(x) x[2], character(1))
  size_v <- vapply(parts, function(x) x[3], character(1))
  hrefs <- vapply(parts, function(x) x[4], character(1))
  names_v <- vapply(parts, function(x) x[5], character(1))
  urls <- ifelse(grepl("^https?://", hrefs), hrefs,
                 paste0(aemo_base_url(), hrefs))

  data.frame(
    name = names_v,
    modified = mod_v,
    size = size_v,
    url = urls,
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
