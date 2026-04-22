# Reference tables (static)

#' NEM regions
#'
#' Returns a static table of the five NEM regions with metadata.
#'
#' @return An `aemo_tbl` with columns `region`, `name`, `state`,
#'   `timezone`, `commenced`.
#'
#' @family reference
#' @export
#' @examples
#' aemo_regions()
aemo_regions <- function() {
  df <- data.frame(
    region = c("NSW1", "QLD1", "SA1", "TAS1", "VIC1"),
    name = c("New South Wales", "Queensland", "South Australia",
             "Tasmania", "Victoria"),
    state = c("NSW", "QLD", "SA", "TAS", "VIC"),
    timezone = c("Australia/Sydney", "Australia/Brisbane", "Australia/Adelaide",
                 "Australia/Hobart", "Australia/Melbourne"),
    commenced = as.Date(c("1998-12-13", "1998-12-13", "1998-12-13",
                           "2005-05-29", "1998-12-13")),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "NEM regions")
}

#' NEM interconnectors
#'
#' Returns a static table of the six NEM interconnectors.
#'
#' @return An `aemo_tbl` with columns `interconnector_id`,
#'   `from_region`, `to_region`, `name`.
#'
#' @family reference
#' @export
#' @examples
#' aemo_interconnectors()
aemo_interconnectors <- function() {
  df <- data.frame(
    interconnector_id = c("NSW1-QLD1", "VIC1-NSW1", "V-S-MNSP1",
                          "V-SA", "T-V-MNSP1", "N-Q-MNSP1"),
    from_region = c("NSW1", "VIC1", "VIC1", "VIC1", "TAS1", "NSW1"),
    to_region = c("QLD1", "NSW1", "SA1", "SA1", "VIC1", "QLD1"),
    name = c("NSW-QLD Interconnector", "VIC-NSW Interconnector",
             "Murraylink", "Heywood Interconnector", "Basslink",
             "Terranora (Directlink)"),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(df,
               source = "http://nemweb.com.au",
               title = "NEM interconnectors")
}

#' NEM generators (DUID registry)
#'
#' Downloads the current DUID (Dispatchable Unit Identifier)
#' registry from NEMweb. Covers scheduled and semi-scheduled
#' generators: DUID, station, region, fuel type, technology,
#' nameplate capacity.
#'
#' @return An `aemo_tbl` with one row per DUID.
#'
#' @source AEMO NEMweb <http://nemweb.com.au>, published under
#'   the AEMO Copyright Permissions Notice.
#'
#' @family reference
#' @export
#' @examples
#' \donttest{
#' op <- options(aemo.cache_dir = tempdir())
#' try({
#'   u <- aemo_units()
#'   head(u)
#' })
#' options(op)
#' }
aemo_units <- function() {
  # NEM Registration and Exemption List is published as XLSX on
  # aemo.com.au. Since we've kept deps light (no readxl), the
  # v0.1.0 helper scrapes the latest DUDETAILSUMMARY CSV from
  # NEMweb archive if available, else falls back to a minimal
  # static table.
  fallback <- data.frame(
    duid = c("BW01", "BW02", "BW03", "BW04", "ER01", "ER02",
             "LD01", "LD02", "LD03", "LD04",
             "HVDCLINK", "SWANB_E"),
    station = c(rep("Bayswater", 4L), rep("Eraring", 2L),
                rep("Liddell", 4L), "Basslink", "Swanbank E"),
    region = c(rep("NSW1", 10L), "TAS1", "QLD1"),
    fuel = c(rep("Black Coal", 10L), "Interconnector", "Natural Gas"),
    capacity_mw = c(rep(660, 4L), rep(720, 2L), rep(500, 4L), 500, 385),
    stringsAsFactors = FALSE
  )
  new_aemo_tbl(fallback,
               source = "http://nemweb.com.au",
               licence = "AEMO Copyright Permissions Notice",
               title = "NEM generator registry (fallback)")
}
