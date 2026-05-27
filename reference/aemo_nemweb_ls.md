# List files in a NEMweb directory

Returns a data frame of files in a NEMweb path, parsed from the Apache
directory-listing HTML.

## Usage

``` r
aemo_nemweb_ls(path)
```

## Source

AEMO NEMweb <http://nemweb.com.au>, published under the AEMO Copyright
Permissions Notice.

## Arguments

- path:

  NEMweb subpath (e.g. `"/Reports/Current/DispatchIS_Reports/"`).
  Leading and trailing slashes are optional.

## Value

A data frame with `name`, `modified`, `size`, `url`.

## See also

Other low-level:
[`aemo_nemweb_download()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_download.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
  head(files)
})
#> Error in aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/") : 
#>   NEMweb returned HTTP 403 for
#> <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/>.
options(op)
# }
```
