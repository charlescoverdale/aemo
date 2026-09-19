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
#>                                                  name
#> 1 PUBLIC_DISPATCHIS_202609172035_0000000538398404.zip
#> 2 PUBLIC_DISPATCHIS_202609172040_0000000538398953.zip
#> 3 PUBLIC_DISPATCHIS_202609172045_0000000538399511.zip
#> 4 PUBLIC_DISPATCHIS_202609172050_0000000538400051.zip
#> 5 PUBLIC_DISPATCHIS_202609172055_0000000538400775.zip
#> 6 PUBLIC_DISPATCHIS_202609172100_0000000538401262.zip
#>                                modified  size
#> 1 Thursday, September 17, 2026 08:31 PM 18748
#> 2 Thursday, September 17, 2026 08:35 PM 18970
#> 3 Thursday, September 17, 2026 08:41 PM 18944
#> 4 Thursday, September 17, 2026 08:45 PM 18969
#> 5 Thursday, September 17, 2026 08:51 PM 18861
#> 6 Thursday, September 17, 2026 08:56 PM 18742
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172035_0000000538398404.zip
#> 2 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172040_0000000538398953.zip
#> 3 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172045_0000000538399511.zip
#> 4 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172050_0000000538400051.zip
#> 5 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172055_0000000538400775.zip
#> 6 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202609172100_0000000538401262.zip
options(op)
# }
```
