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
#> 1 PUBLIC_DISPATCHIS_202604270515_0000000514938186.zip
#> 2 PUBLIC_DISPATCHIS_202604270520_0000000514938712.zip
#> 3 PUBLIC_DISPATCHIS_202604270525_0000000514939462.zip
#> 4 PUBLIC_DISPATCHIS_202604270530_0000000514939861.zip
#> 5 PUBLIC_DISPATCHIS_202604270535_0000000514940389.zip
#> 6 PUBLIC_DISPATCHIS_202604270540_0000000514940812.zip
#>                          modified  size
#> 1 Monday, April 27, 2026  5:10 AM 18432
#> 2 Monday, April 27, 2026  5:15 AM 18370
#> 3 Monday, April 27, 2026  5:20 AM 18371
#> 4 Monday, April 27, 2026  5:25 AM 18463
#> 5 Monday, April 27, 2026  5:30 AM 18431
#> 6 Monday, April 27, 2026  5:35 AM 18373
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270515_0000000514938186.zip
#> 2 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270520_0000000514938712.zip
#> 3 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270525_0000000514939462.zip
#> 4 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270530_0000000514939861.zip
#> 5 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270535_0000000514940389.zip
#> 6 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604270540_0000000514940812.zip
options(op)
# }
```
