# AEMO CSV row format parser
#
# AEMO NEMweb files are zipped CSVs with row-type prefixes:
#   C,<comment fields>             -- file comment (one at top, one at bottom)
#   I,<report>,<table>,<ver>,<col1>,<col2>,...  -- column header
#   D,<report>,<table>,<ver>,<val1>,<val2>,...  -- data row
#   F,<report>,<table>,<ver>,...   -- file footer with row count
#
# A single file may contain multiple (report, table, ver) tuples
# with independent I/D row streams. We dispatch by reading the I
# row to set the schema, then accumulate subsequent D rows.

#' Parse an AEMO CSV file into one data frame per table
#'
#' @param path Path to an unzipped AEMO CSV file.
#' @return A named list of data frames, keyed by
#'   `<REPORT>_<TABLE>`.
#' @noRd
aemo_parse_csv <- function(path) {
  con <- file(path, open = "r")
  on.exit(close(con), add = TRUE)

  schemas <- list()
  streams <- list()
  current <- NULL

  while (length(line <- readLines(con, n = 1L, warn = FALSE)) > 0L) {
    tag <- substr(line, 1L, 1L)
    if (tag == "C" || tag == "F") next
    # scan(text = ) opens and closes its own connection; an explicit
    # textConnection() here was never closed, leaking one per line.
    parts <- scan(text = line, what = "character",
                  sep = ",", quiet = TRUE, strip.white = TRUE,
                  na.strings = "", quote = "\"")
    if (length(parts) < 4L) next
    key <- paste(parts[2], parts[3], sep = "_")

    if (tag == "I") {
      cols <- parts[5:length(parts)]
      schemas[[key]] <- cols
      streams[[key]] <- list()
      current <- key
    } else if (tag == "D") {
      vals <- parts[5:length(parts)]
      if (is.null(schemas[[key]])) next
      # Pad vals to match schema length
      n <- length(schemas[[key]])
      vals <- c(vals, rep(NA_character_, max(0L, n - length(vals))))[seq_len(n)]
      streams[[key]][[length(streams[[key]]) + 1L]] <- vals
    }
  }

  out <- list()
  for (key in names(streams)) {
    rows <- streams[[key]]
    if (length(rows) == 0L) next
    mat <- do.call(rbind, rows)
    df <- as.data.frame(mat, stringsAsFactors = FALSE)
    names(df) <- aemo_clean_names(schemas[[key]])
    out[[tolower(key)]] <- df
  }
  out
}

#' Download, unzip, and parse an AEMO zipped CSV into tables
#'
#' @param url URL to an AEMO zipped CSV.
#' @param start,end Optional POSIXct window. Inner files of an Archive
#'   rollup named by an interval outside it are skipped.
#' @return Named list of data frames keyed by `<report>_<table>`.
#' @noRd
aemo_fetch_zip <- function(url, start = NULL, end = NULL) {
  zip_path <- aemo_download_cached(url)
  tmp <- tempfile("aemo_unzip_")
  dir.create(tmp, recursive = TRUE)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  utils::unzip(zip_path, exdir = tmp)

  # Archive rollups are zips of zips: a daily DispatchIS archive holds
  # the 288 five-minute zips for that day. When a time window is given,
  # drop inner files whose interval falls outside it before parsing, so an
  # hour's query reads a dozen files rather than the whole day.
  if (!is.null(start) && !is.null(end)) {
    inner <- list.files(tmp, pattern = "\\.[Zz][Ii][Pp]$", full.names = TRUE)
    ts <- aemo_file_timestamp(basename(inner))
    buffer <- as.difftime(5, units = "mins")
    drop <- !is.na(ts) & (ts < start - buffer | ts > end + buffer)
    unlink(inner[drop])
  }
  # Unpack nested zips until only CSVs remain.
  repeat {
    inner <- list.files(tmp, pattern = "\\.[Zz][Ii][Pp]$", full.names = TRUE,
                        recursive = TRUE)
    if (length(inner) == 0L) break
    for (z in inner) {
      utils::unzip(z, exdir = dirname(z))
      unlink(z)
    }
  }

  csvs <- sort(list.files(tmp, pattern = "\\.[Cc][Ss][Vv]$", full.names = TRUE,
                          recursive = TRUE))
  if (length(csvs) == 0L) {
    cli::cli_abort("No CSV files found inside {.file {basename(zip_path)}}.")
  }
  # Collect every file's tables first and bind once per table, on the
  # columns all files share.
  pieces <- list()
  for (p in csvs) {
    parsed <- aemo_parse_csv(p)
    for (k in names(parsed)) {
      pieces[[k]][[length(pieces[[k]]) + 1L]] <- parsed[[k]]
    }
  }
  lapply(pieces, function(parts) {
    if (length(parts) == 1L) return(parts[[1L]])
    common <- Reduce(intersect, lapply(parts, names))
    out <- do.call(rbind, lapply(parts, function(d) d[, common, drop = FALSE]))
    rownames(out) <- NULL
    out
  })
}
