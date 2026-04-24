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
#> 1 PUBLIC_DISPATCHIS_202604230035_0000000514252786.zip
#> 2 PUBLIC_DISPATCHIS_202604230040_0000000514253366.zip
#> 3 PUBLIC_DISPATCHIS_202604230045_0000000514254068.zip
#> 4 PUBLIC_DISPATCHIS_202604230050_0000000514254565.zip
#> 5 PUBLIC_DISPATCHIS_202604230055_0000000514255115.zip
#> 6 PUBLIC_DISPATCHIS_202604230100_0000000514255617.zip
#>                            modified  size
#> 1 Thursday, April 23, 2026 12:30 AM 19328
#> 2 Thursday, April 23, 2026 12:35 AM 19211
#> 3 Thursday, April 23, 2026 12:40 AM 19225
#> 4 Thursday, April 23, 2026 12:45 AM 19142
#> 5 Thursday, April 23, 2026 12:50 AM 19134
#> 6 Thursday, April 23, 2026 12:55 AM 19255
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230035_0000000514252786.zip
#> 2 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230040_0000000514253366.zip
#> 3 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230045_0000000514254068.zip
#> 4 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230050_0000000514254565.zip
#> 5 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230055_0000000514255115.zip
#> 6 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230100_0000000514255617.zip
options(op)
# }
```
