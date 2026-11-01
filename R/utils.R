# Internal helpers

#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

#' Build a verified MMSDM archive URL for a named table.
#'
#' MMSDM monthly archives use the naming convention:
#' `PUBLIC_ARCHIVE#TABLENAME#FILE01#YYYYMM010000.zip`
#' (with `#` URL-encoded as `%23`). This helper constructs the
#' URL and is the single source of truth for the pattern.
#'
#' The base URL is read from `options("aemo.mmsdm_base")` so the
#' 30 April 2026 NEMweb migration can be handled without a
#' reinstall.
#'
#' @param table  AEMO table name in UPPER_CASE (e.g. "DUDETAILSUMMARY").
#' @param year   4-digit year string (e.g. "2025").
#' @param month  2-digit month string with leading zero (e.g. "03").
#' @param base   MMSDM base URL. Defaults to the current NEMweb path;
#'   set `options(aemo.mmsdm_base = "...")` to override globally.
#' @return A fully-qualified URL string.
#' @noRd
AEMO_MMSDM_BASE <- "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM"

#' @noRd
aemo_mmsdm_base <- function() {
  getOption("aemo.mmsdm_base", default = AEMO_MMSDM_BASE)
}

#' @noRd
aemo_mmsdm_url <- function(table, year, month,
                             base = aemo_mmsdm_base()) {
  sprintf(
    "%s/%s/MMSDM_%s_%s/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_ARCHIVE%%23%s%%23FILE01%%23%s%s010000.zip",
    base, year, year, month, table, year, month
  )
}

#' Fetch one MMSDM table from recent monthly archives, trying back
#' up to `max_months_back` months. Returns the first data frame
#' with at least `min_rows` rows, or NULL.
#' @noRd
aemo_fetch_mmsdm_table <- function(table, min_rows = 1L,
                                    max_months_back = 6L) {
  now <- Sys.time()
  attr(now, "tzone") <- AEMO_TIMEZONE
  for (offset in seq_len(max_months_back)) {
    target <- as.Date(now) - (offset * 30L)
    y <- format(target, "%Y")
    m <- format(target, "%m")
    url <- aemo_mmsdm_url(table, y, m)
    df <- tryCatch({
      zip_path <- aemo_download_cached(url)
      tmp <- tempfile(paste0("aemo_", tolower(table), "_"))
      dir.create(tmp, recursive = TRUE)
      on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
      utils::unzip(zip_path, exdir = tmp)
      csvs <- list.files(tmp, pattern = "\\.[Cc][Ss][Vv]$",
                         full.names = TRUE)
      if (length(csvs) == 0L) stop("no csv in zip")
      parsed <- aemo_parse_csv(csvs[[1L]])
      if (length(parsed) == 0L) stop("empty parse")
      parsed[[1L]]
    }, error = function(e) NULL)
    if (!is.null(df) && nrow(df) >= min_rows) {
      return(aemo_coerce_types(df))
    }
  }
  NULL
}

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

#' NEM market timezone: fixed AEST (UTC+10), no daylight savings.
#'
#' AEMO operates the NEM on Australian Eastern Standard Time
#' year-round (National Electricity Rules clause 2.2.6). We use
#' `"Australia/Brisbane"` rather than `"Australia/Sydney"`
#' because Sydney observes DST and would silently shift every
#' summer timestamp by one hour relative to the AEMO file clock.
#' @noRd
AEMO_TIMEZONE <- "Australia/Brisbane"

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

#' Parse a user-supplied timestamp to POSIXct in AEMO market time.
#'
#' Always returns AEST (UTC+10, no DST) to match the clock used
#' throughout NEMweb files.
#' @noRd
aemo_parse_time <- function(x) {
  if (inherits(x, "POSIXct")) {
    return(as.POSIXct(format(x, tz = AEMO_TIMEZONE),
                      tz = AEMO_TIMEZONE))
  }
  if (inherits(x, "Date")) {
    return(as.POSIXct(paste0(x, " 00:00:00"), tz = AEMO_TIMEZONE))
  }
  if (is.character(x)) {
    return(as.POSIXct(x, tz = AEMO_TIMEZONE))
  }
  cli::cli_abort("Could not parse time {.val {x}}.")
}

#' Parse an AEMO-format timestamp column to POSIXct AEST.
#'
#' AEMO timestamps appear in several near-identical forms across
#' tables and vintages: `"2024/06/01 00:05:00"`,
#' `"2024-06-01 00:05:00"`, and occasionally ISO 8601. This
#' helper tries each in turn.
#' @noRd
aemo_parse_col_time <- function(x) {
  x <- as.character(x)
  out <- rep(as.POSIXct(NA, tz = AEMO_TIMEZONE), length(x))
  fmts <- c("%Y/%m/%d %H:%M:%S", "%Y-%m-%d %H:%M:%S",
            "%Y/%m/%d %H:%M", "%Y-%m-%d %H:%M",
            "%Y/%m/%dT%H:%M:%S", "%Y-%m-%dT%H:%M:%S")
  for (fmt in fmts) {
    todo <- is.na(out) & !is.na(x) & nzchar(x)
    if (!any(todo)) break
    parsed <- suppressWarnings(
      as.POSIXct(x[todo], format = fmt, tz = AEMO_TIMEZONE)
    )
    out[todo][!is.na(parsed)] <- parsed[!is.na(parsed)]
  }
  out
}

#' Extract the timestamp encoded in a NEMweb filename.
#'
#' Filenames follow the pattern
#' `PUBLIC_<REPORT>_YYYYMMDDHHMM_<seq>.zip` (or `YYYYMMDD` for
#' Archive daily rollups). Returns POSIXct in AEMO_TIMEZONE or
#' NA for filenames that do not match.
#' @noRd
aemo_file_timestamp <- function(filenames) {
  out <- rep(as.POSIXct(NA, tz = AEMO_TIMEZONE), length(filenames))
  # regexpr() keeps one entry per input (-1 for no match), so matches stay
  # aligned with `filenames`; regmatches() alone would drop non-matches.
  first_match <- function(x, rx) {
    m <- regexpr(rx, x)
    ifelse(m > 0L, substring(x, m, m + attr(m, "match.length") - 1L), NA)
  }
  # Try 12-digit (YYYYMMDDHHMM) first
  m12 <- first_match(filenames, "[0-9]{12}")
  ok <- !is.na(m12)
  out[ok] <- suppressWarnings(
    as.POSIXct(m12[ok], format = "%Y%m%d%H%M", tz = AEMO_TIMEZONE)
  )
  # Fall back to 8-digit (YYYYMMDD) for Archive rollups
  todo <- is.na(out)
  m8 <- first_match(filenames[todo], "[0-9]{8}")
  ok8 <- !is.na(m8)
  out[which(todo)[ok8]] <- suppressWarnings(
    as.POSIXct(m8[ok8], format = "%Y%m%d", tz = AEMO_TIMEZONE)
  )
  out
}

#' Calendar days of intervals held in each NEMweb Archive rollup.
#'
#' Daily rollups (`PUBLIC_DISPATCHIS_20260902.zip`) hold the intervals
#' ending 00:05 on that day to 00:00 the next. Weekly rollups
#' (`PUBLIC_TRADINGIS_20251012_20251018.zip`) span the two dates named.
#' @param filenames Archive file names.
#' @return A list of Date vectors, one per file.
#' @noRd
aemo_archive_days <- function(filenames) {
  lapply(filenames, function(f) {
    d <- regmatches(f, gregexpr("(?<![0-9])[0-9]{8}(?![0-9])", f, perl = TRUE))[[1]]
    d <- as.Date(d, format = "%Y%m%d")
    d <- d[!is.na(d)]
    if (length(d) == 0L) return(as.Date(character(0)))
    seq(min(d), max(d), by = "day")
  })
}

#' List NEMweb Current-directory files in a date range.
#'
#' @param path NEMweb subpath under `/Reports/Current/`.
#' @param pattern Regex applied to filenames (e.g. `"DISPATCHIS"`).
#' @param start,end POSIXct in AEMO_TIMEZONE.
#' @return A data frame of files (name, url, file_ts), filtered.
#' @noRd
aemo_select_files_in_range <- function(path, pattern, start, end) {
  files <- aemo_nemweb_ls(path)
  if (nrow(files) == 0L) {
    return(data.frame(name = character(0), url = character(0),
                      file_ts = as.POSIXct(character(0), tz = AEMO_TIMEZONE),
                      stringsAsFactors = FALSE))
  }
  files <- files[grepl(pattern, files$name, ignore.case = TRUE), ,
                 drop = FALSE]
  if (nrow(files) == 0L) return(files)
  files$file_ts <- aemo_file_timestamp(files$name)
  # NEM dispatch files are named by their period-end timestamp;
  # the file named 00:05 contains data for the 5-min period
  # ending at 00:05. Allow a 5-min buffer on each side.
  buffer <- as.difftime(5, units = "mins")
  keep <- !is.na(files$file_ts) &
    files$file_ts >= (start - buffer) &
    files$file_ts <= (end + buffer)
  files[keep, , drop = FALSE]
}

#' Coerce character columns to likely types based on column names.
#'
#' NEMweb CSV parsing returns every column as character. This
#' helper applies a conservative type coercion:
#' - Columns named `*DATE*`, `*DATETIME*`, `*INTERVAL_DATETIME*`
#'   are parsed as POSIXct in AEMO_TIMEZONE.
#' - Columns whose names match known numeric patterns (RRP,
#'   PRICE, MW, FACTOR, LIMIT, LOSS, VOLUME, CAPACITY, DEMAND,
#'   GENERATION, FLOW, ENABLEMENT, INTERCHANGE, and the 10-band
#'   bid price/availability columns) are coerced to numeric.
#' - ID / text columns (DUID, REGIONID, STATION, INTERVENTION,
#'   RUNNO, HUBID, MARKETSUSPENDEDFLAG, etc.) stay character.
#' @noRd
aemo_coerce_types <- function(df) {
  if (!is.data.frame(df) || ncol(df) == 0L) return(df)
  nm <- names(df)
  # Time columns: name ends in "date" or contains "datetime"/"interval_datetime"/"settlementdate"
  time_cols <- grep("(date$|datetime|settlementdate|interval_datetime)",
                    nm, value = TRUE)
  for (col in time_cols) {
    parsed <- aemo_parse_col_time(df[[col]])
    if (sum(!is.na(parsed)) > 0L) df[[col]] <- parsed
  }
  # Numeric columns: explicit known tokens (conservative).
  # "intervention" is numeric 0/1 but kept as character to match
  # the rest of AEMO's flag columns.
  num_tokens <- c(
    "rrp$", "price$", "pricerrp$",
    "^mw", "mw$", "_mw",
    "availability", "availability_mw",
    "demand", "generation", "interchange", "flow",
    "losses", "lossfactor", "marginalvalue", "shadowprice",
    "enablement", "dispatch", "target",
    "priceband", "bandavail", "maxavail",
    "rooftop_pv", "scada", "capacity",
    "total", "lor", "reserve",
    "nplong", "npshort"
  )
  num_re <- paste(num_tokens, collapse = "|")
  num_cols <- grep(num_re, nm, value = TRUE, ignore.case = TRUE)
  # Exclude columns already parsed as time + flag-like columns.
  num_cols <- setdiff(num_cols, time_cols)
  num_cols <- setdiff(num_cols, grep("^(runno|regionid|duid|marketsuspendedflag|intervention|semi_dispatch_cap)$",
                                      nm, value = TRUE))
  for (col in num_cols) {
    parsed <- suppressWarnings(as.numeric(df[[col]]))
    # Only replace if a material share parses (>30%). Otherwise
    # the column is probably not numeric despite the name match.
    non_na_char <- sum(!is.na(df[[col]]) & nzchar(as.character(df[[col]])))
    if (non_na_char > 0L && sum(!is.na(parsed)) / non_na_char > 0.3) {
      df[[col]] <- parsed
    }
  }
  df
}

#' Apply range + intervention + region filters to a parsed
#' AEMO table.
#'
#' @param df A data frame from `aemo_parse_csv()`.
#' @param start,end POSIXct bounds.
#' @param region Optional character vector of region IDs.
#' @param intervention Logical: include intervention runs?
#'   Default `FALSE` filters to `INTERVENTION = 0`.
#' @noRd
aemo_apply_filters <- function(df, start = NULL, end = NULL,
                                region = NULL, intervention = FALSE) {
  if (is.null(df) || nrow(df) == 0L) return(df)
  if (!is.null(region) && "regionid" %in% names(df)) {
    df <- df[df$regionid %in% toupper(region), , drop = FALSE]
  }
  if (!intervention && "intervention" %in% names(df)) {
    iv <- suppressWarnings(as.integer(df$intervention))
    df <- df[is.na(iv) | iv == 0L, , drop = FALSE]
  }
  if ((!is.null(start) || !is.null(end)) && "settlementdate" %in% names(df)) {
    ts <- if (inherits(df$settlementdate, "POSIXct")) {
      df$settlementdate
    } else {
      aemo_parse_col_time(df$settlementdate)
    }
    keep <- !is.na(ts)
    if (!is.null(start)) keep <- keep & ts >= start
    if (!is.null(end))   keep <- keep & ts <= end
    df <- df[keep, , drop = FALSE]
  }
  rownames(df) <- NULL
  df
}

#' Fetch a NEMweb report over a date range and stitch results.
#'
#' NEMweb keeps two copies of most reports: the five-minute (or
#' half-hourly) files in `Current/`, held for only a couple of days, and
#' daily or weekly rollups in `Archive/`, held for about 13 months. Rather
#' than assume a fixed retention, each calendar day in the range is taken
#' from an Archive rollup when one covers it, and from `Current/` files
#' otherwise. Older data lives in MMSDM.
#'
#' @param current_dir NEMweb Current subpath (e.g.
#'   `"/Reports/Current/DispatchIS_Reports/"`).
#' @param archive_dir NEMweb Archive subpath, or `NULL` if the
#'   report has no Archive rollup.
#' @param pattern Filename regex (e.g. `"DISPATCHIS"`).
#' @param start,end POSIXct AEST.
#' @param table Name of the parsed table to extract from each
#'   file (lowercase `<report>_<table>`, e.g. `"dispatch_price"`).
#'   If `NULL`, returns the first table per file.
#' @return A single stacked data frame (character types before
#'   user coercion).
#' @noRd
aemo_fetch_report_range <- function(current_dir, archive_dir = NULL,
                                     pattern, start, end, table = NULL) {
  # Files are named by interval end, so the interval ending at 00:00
  # belongs to the previous day's rollup; step back one second.
  one_sec <- as.difftime(1, units = "secs")
  days <- seq(as.Date(start - one_sec, tz = AEMO_TIMEZONE),
              as.Date(end - one_sec, tz = AEMO_TIMEZONE), by = "day")

  urls <- character(0)
  covered <- as.Date(character(0))
  earliest_archive <- NA

  if (!is.null(archive_dir)) {
    arch <- aemo_nemweb_ls(archive_dir)
    arch <- arch[grepl(pattern, arch$name, ignore.case = TRUE), , drop = FALSE]
    if (nrow(arch) > 0L) {
      spans <- aemo_archive_days(arch$name)
      earliest_archive <- suppressWarnings(min(do.call(c, spans)))
      hit <- vapply(spans, function(d) any(d %in% days), logical(1))
      urls <- c(urls, arch$url[hit])
      covered <- unique(do.call(c, c(list(as.Date(character(0))), spans[hit])))
    }
  }

  if (!all(days %in% covered)) {
    cur <- aemo_select_files_in_range(current_dir, pattern, start, end)
    if (nrow(cur) > 0L) {
      cur_day <- as.Date(cur$file_ts - one_sec, tz = AEMO_TIMEZONE)
      urls <- c(urls, cur$url[!cur_day %in% covered])
    }
  }

  if (length(urls) == 0L) {
    held <- if (!is.na(earliest_archive)) {
      paste0("NEMweb holds this report from {.val ", format(earliest_archive),
             "}; earlier data is in MMSDM (see {.fn aemo_nemweb_download}).")
    } else {
      "Older data is in MMSDM (see {.fn aemo_nemweb_download})."
    }
    cli::cli_abort(c(
      "No NEMweb files matched the requested range.",
      "i" = "Check {.arg start} and {.arg end}, or the pattern {.val {pattern}}.",
      "i" = held
    ))
  }

  all_parts <- list()
  failed <- character(0)
  for (url in urls) {
    tables <- tryCatch(aemo_fetch_zip(url, start = start, end = end),
                       error = function(e) {
                         failed <<- c(failed, url)
                         NULL
                       })
    if (is.null(tables)) next
    df <- if (!is.null(table) && !is.null(tables[[table]])) {
      tables[[table]]
    } else if (length(tables) > 0L) {
      tables[[1L]]
    } else NULL
    if (!is.null(df) && nrow(df) > 0L) {
      all_parts[[length(all_parts) + 1L]] <- df
    }
  }

  if (length(all_parts) == 0L) {
    if (length(failed) > 0L) {
      cli::cli_abort(c(
        "Every NEMweb download for the requested range failed.",
        "i" = "{length(failed)} file{?s}, for example {.url {failed[1]}}.",
        "i" = "NEMweb may be slow or unavailable; try again later."
      ), class = "aemo_download_error")
    }
    cli::cli_abort("No data rows found in the fetched files.")
  }
  # A partial result is easy to mistake for a complete one, so say so once,
  # plainly, rather than once per file.
  if (length(failed) > 0L) {
    cli::cli_warn(c(
      "{length(failed)} of {length(urls)} NEMweb file{?s} could not be downloaded, so the result is missing those intervals.",
      "i" = "Missing: {.url {failed}}",
      "i" = "Run the call again to retry; files already downloaded are reused from the cache."
    ), class = "aemo_partial_download")
  }

  # Stack on common columns only (handles schema drift)
  common <- Reduce(intersect, lapply(all_parts, names))
  common <- common[nzchar(common)]
  stacked <- do.call(
    rbind,
    lapply(all_parts, function(d) d[, common, drop = FALSE])
  )
  rownames(stacked) <- NULL
  stacked
}
