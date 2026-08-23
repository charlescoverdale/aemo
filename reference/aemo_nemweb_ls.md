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
#> 1 PUBLIC_DISPATCHIS_202608220340_0000000533827925.zip
#> 2 PUBLIC_DISPATCHIS_202608220345_0000000533828428.zip
#> 3 PUBLIC_DISPATCHIS_202608220350_0000000533828921.zip
#> 4 PUBLIC_DISPATCHIS_202608220355_0000000533829573.zip
#> 5 PUBLIC_DISPATCHIS_202608220400_0000000533830067.zip
#> 6 PUBLIC_DISPATCHIS_202608220405_0000000533830589.zip
#>                             modified  size
#> 1 Saturday, August 22, 2026 03:37 AM 19427
#> 2 Saturday, August 22, 2026 03:42 AM 19425
#> 3 Saturday, August 22, 2026 03:47 AM 19438
#> 4 Saturday, August 22, 2026 03:51 AM 19414
#> 5 Saturday, August 22, 2026 03:56 AM 19367
#> 6 Saturday, August 22, 2026 04:01 AM 19483
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220340_0000000533827925.zip
#> 2 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220345_0000000533828428.zip
#> 3 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220350_0000000533828921.zip
#> 4 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220355_0000000533829573.zip
#> 5 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220400_0000000533830067.zip
#> 6 http://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202608220405_0000000533830589.zip
options(op)
# }
```
