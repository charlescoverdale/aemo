# Settlement cash-flow and residue tables

Returns settlement reconciliation tables from MMSDM. Three views are
exposed, corresponding to the three tables gentailer hedging workflows
most commonly need:

## Usage

``` r
aemo_settlement(table = c("cashflow", "fcas_recovery", "residues"), start, end)
```

## Source

AEMO NEMweb MMSDM archive, SETCFM / SETFCASREGIONRECOVERY /
SETRESIDUECONTRACTPAYMENT. AEMO Copyright Permissions Notice.

## Arguments

- table:

  One of `"cashflow"`, `"fcas_recovery"`, or `"residues"`.

- start, end:

  Window (inclusive) applied to `SETTLEMENTDATE` / `PAYMENTDATE`.

## Value

An `aemo_tbl` with the raw MMSDM columns for the requested table.

## Details

- `"cashflow"` (default): `SETCFM` (NEMDE-derived energy settlement
  amounts per participant per trading interval).

- `"fcas_recovery"`: `SETFCASREGIONRECOVERY` (the recovery allocation of
  FCAS costs to customer load per region per trading interval).

- `"residues"`: `SETRESIDUECONTRACTPAYMENT` (settlement residue auction
  (SRA) contract payments against interconnector settlement residues).

**Access.** These tables are in the MMSDM monthly archive (not the
NEMweb Current retention). Expect two-month latency between trading date
and availability.

## See also

[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md)
for the transmission loss factors that scale settlement amounts;
[`aemo_interconnector()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnector.md)
for the flow side of the residue calculation.

Other reference:
[`aemo_dlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_dlf.md),
[`aemo_interconnectors()`](https://charlescoverdale.github.io/aemo/reference/aemo_interconnectors.md),
[`aemo_mlf()`](https://charlescoverdale.github.io/aemo/reference/aemo_mlf.md),
[`aemo_participants()`](https://charlescoverdale.github.io/aemo/reference/aemo_participants.md),
[`aemo_price_caps()`](https://charlescoverdale.github.io/aemo/reference/aemo_price_caps.md),
[`aemo_regions()`](https://charlescoverdale.github.io/aemo/reference/aemo_regions.md),
[`aemo_snapshot()`](https://charlescoverdale.github.io/aemo/reference/aemo_snapshot.md),
[`aemo_units()`](https://charlescoverdale.github.io/aemo/reference/aemo_units.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  s <- aemo_settlement(table = "cashflow",
                        start = "2024-06-01",
                        end   = "2024-06-02")
  head(s)
})
#> ℹ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> ✖ Downloading <https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2…
#> 
#> Error in aemo_settlement(table = "cashflow", start = "2024-06-01", end = "2024-06-02") : 
#>   Could not retrieve SETCFM from MMSDM.
#> ℹ Settlement tables are published with ~2 month latency. Check that "2024-06"
#>   is within the published window.
options(op)
# }
```
