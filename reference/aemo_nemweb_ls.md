# List files in a NEMweb directory

Returns a data frame of files in a NEMweb path, parsed from the Apache
directory-listing HTML.

## Usage

``` r
aemo_nemweb_ls(path)
```

## Source

AEMO NEMweb <https://nemweb.com.au>, published under the AEMO Copyright
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
#>                                                  name
#> 1 PUBLIC_DISPATCHIS_202610310010_0000000545771227.zip
#> 2 PUBLIC_DISPATCHIS_202610310015_0000000545771804.zip
#> 3 PUBLIC_DISPATCHIS_202610310020_0000000545772428.zip
#> 4 PUBLIC_DISPATCHIS_202610310025_0000000545773160.zip
#> 5 PUBLIC_DISPATCHIS_202610310030_0000000545773703.zip
#> 6 PUBLIC_DISPATCHIS_202610310035_0000000545774268.zip
#>                              modified  size
#> 1 Saturday, October 31, 2026 12:05 AM 20989
#> 2 Saturday, October 31, 2026 12:10 AM 21021
#> 3 Saturday, October 31, 2026 12:15 AM 20983
#> 4 Saturday, October 31, 2026 12:20 AM 21055
#> 5 Saturday, October 31, 2026 12:25 AM 20889
#> 6 Saturday, October 31, 2026 12:31 AM 20933
#>                                                                                                            url
#> 1 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310010_0000000545771227.zip
#> 2 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310015_0000000545771804.zip
#> 3 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310020_0000000545772428.zip
#> 4 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310025_0000000545773160.zip
#> 5 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310030_0000000545773703.zip
#> 6 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202610310035_0000000545774268.zip
options(op)
# }
```
