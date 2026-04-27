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
#> 1 PUBLIC_DISPATCHIS_202604260655_0000000514790112.zip
#> 2 PUBLIC_DISPATCHIS_202604260700_0000000514790554.zip
#> 3 PUBLIC_DISPATCHIS_202604260705_0000000514791034.zip
#> 4 PUBLIC_DISPATCHIS_202604260710_0000000514792101.zip
#> 5 PUBLIC_DISPATCHIS_202604260715_0000000514792590.zip
#> 6 PUBLIC_DISPATCHIS_202604260720_0000000514793101.zip
#>                          modified  size
#> 1 Sunday, April 26, 2026  6:50 AM 19726
#> 2 Sunday, April 26, 2026  6:55 AM 19638
#> 3 Sunday, April 26, 2026  7:00 AM 20520
#> 4 Sunday, April 26, 2026  7:05 AM 20464
#> 5 Sunday, April 26, 2026  7:10 AM 20528
#> 6 Sunday, April 26, 2026  7:15 AM 20234
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260655_0000000514790112.zip
#> 2 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260700_0000000514790554.zip
#> 3 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260705_0000000514791034.zip
#> 4 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260710_0000000514792101.zip
#> 5 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260715_0000000514792590.zip
#> 6 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202604260720_0000000514793101.zip
options(op)
# }
```
