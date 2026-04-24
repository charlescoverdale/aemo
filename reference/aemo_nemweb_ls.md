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
#> 1 PUBLIC_DISPATCHIS_202604222345_0000000514247503.zip
#> 2 PUBLIC_DISPATCHIS_202604222350_0000000514247997.zip
#> 3 PUBLIC_DISPATCHIS_202604222355_0000000514248539.zip
#> 4 PUBLIC_DISPATCHIS_202604230000_0000000514249037.zip
#> 5 PUBLIC_DISPATCHIS_202604230005_0000000514249546.zip
#> 6 PUBLIC_DISPATCHIS_202604230010_0000000514250176.zip
#>                             modified  size
#> 1 Wednesday, April 22, 2026 11:40 PM 19273
#> 2 Wednesday, April 22, 2026 11:45 PM 19325
#> 3 Wednesday, April 22, 2026 11:50 PM 19368
#> 4 Wednesday, April 22, 2026 11:55 PM 19188
#> 5  Thursday, April 23, 2026 12:00 AM 19230
#> 6  Thursday, April 23, 2026 12:05 AM 19115
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604222345_0000000514247503.zip
#> 2 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604222350_0000000514247997.zip
#> 3 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604222355_0000000514248539.zip
#> 4 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230000_0000000514249037.zip
#> 5 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230005_0000000514249546.zip
#> 6 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604230010_0000000514250176.zip
options(op)
# }
```
