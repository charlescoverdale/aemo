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
#' @param table  AEMO table name in UPPER_CASE (e.g. "DUDETAILSUMMARY").
#' @param year   4-digit year string (e.g. "2025").
#' @param month  2-digit month string with leading zero (e.g. "03").
#' @param base   MMSDM base URL.
#' @return A fully-qualified URL string.
#' @noRd
aemo_mmsdm_url <- function(table, year, month,
                             base = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM") {
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
  n <- length(filenames)
  out <- rep(as.POSIXct(NA, tz = AEMO_TIMEZONE), n)
  # Try 12-digit (YYYYMMDDHHMM) first
  m12 <- regmatches(filenames, regexpr("[0-9]{12}", filenames))
  hits12 <- which(nzchar(m12))
  if (length(hits12) > 0L) {
    out[hits12] <- suppressWarnings(
      as.POSIXct(m12[hits12], format = "%Y%m%d%H%M", tz = AEMO_TIMEZONE)
    )
  }
  # Fall back to 8-digit (YYYYMMDD) for Archive daily rollups
  todo <- is.na(out)
  if (any(todo)) {
    m8 <- regmatches(filenames[todo], regexpr("[0-9]{8}", filenames[todo]))
    hits8 <- which(nzchar(m8))
    if (length(hits8) > 0L) {
      parsed <- suppressWarnings(
        as.POSIXct(m8[hits8], format = "%Y%m%d", tz = AEMO_TIMEZONE)
      )
      idx <- which(todo)[hits8]
      out[idx] <- parsed
    }
  }
  out
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
    # Only replace if a material share parses (>30%) — otherwise
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
#' Chooses Current/ for recent dates, Archive/ for older dates
#' (daily rollups). Aborts with a clear message if the requested
#' range is older than NEMweb retention (~30 days for Current,
#' years for Archive; MMSDM for multi-year).
#'
#' @param current_dir NEMweb Current subpath (e.g.
#'   `"/Reports/Current/DispatchIS_Reports/"`).
#' @param archive_dir NEMweb Archive subpath, or `NULL` if the
#'   report has no daily Archive rollup.
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
  now <- Sys.time()
  attr(now, "tzone") <- AEMO_TIMEZONE
  current_window <- now - as.difftime(30, units = "days")

  urls <- character(0)

  if (end >= current_window) {
    current_start <- max(start, current_window)
    files <- aemo_select_files_in_range(current_dir, pattern,
                                         current_start, end)
    urls <- c(urls, files$url)
  }
  if (start < current_window) {
    if (is.null(archive_dir)) {
      cli::cli_abort(c(
        "Requested range extends beyond NEMweb Current retention ({.val {format(current_window, '%Y-%m-%d')}}).",
        "i" = "Archive daily rollups are not yet implemented for this report.",
        "i" = "Use {.fn aemo_nemweb_download} with an explicit MMSDM URL for older data."
      ))
    }
    days <- seq(as.Date(start, tz = AEMO_TIMEZONE),
                min(as.Date(end, tz = AEMO_TIMEZONE),
                    as.Date(current_window, tz = AEMO_TIMEZONE)),
                by = "day")
    files <- aemo_nemweb_ls(archive_dir)
    files <- files[grepl(pattern, files$name, ignore.case = TRUE), ,
                   drop = FALSE]
    if (nrow(files) > 0L) {
      files$file_ts <- aemo_file_timestamp(files$name)
      keep <- !is.na(files$file_ts) &
        as.Date(files$file_ts, tz = AEMO_TIMEZONE) %in% days
      urls <- c(urls, files$url[keep])
    }
  }

  if (length(urls) == 0L) {
    cli::cli_abort(c(
      "No NEMweb files matched the requested range.",
      "i" = "Check {.arg start} and {.arg end}, or the pattern {.val {pattern}}."
    ))
  }

  all_parts <- list()
  for (url in urls) {
    tables <- tryCatch(aemo_fetch_zip(url),
                       error = function(e) {
                         cli::cli_warn("Skipping failed download: {.url {url}}")
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
    cli::cli_abort("No data rows found in the fetched files.")
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
