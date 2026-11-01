# CRAN submission comments: aemo 0.4.3

## Reason for this submission

Bug fixes. NEMweb shortened how long it keeps recent files, so most
queries for data more than two days old failed; archive files were not
unpacked; and the download cache never matched its stored checksum, so
every file was downloaded again on each call. `aemo_bids()` failed for
every date after AEMO emptied one of its source folders, and
`aemo_mlf()` read the wrong monthly archive outside July. Details in
NEWS.md.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN settings, R 4.5.2, macOS).

Live-data tests are skipped on CRAN and run only when
`AEMO_LIVE_TESTS=true`; network examples are wrapped in `try()` inside
`\donttest{}`.

## Downstream dependencies

None on CRAN.
