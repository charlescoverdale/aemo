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
#> 1 PUBLIC_DISPATCHIS_202605030515_0000000515882382.zip
#> 2 PUBLIC_DISPATCHIS_202605030520_0000000515882783.zip
#> 3 PUBLIC_DISPATCHIS_202605030525_0000000515883302.zip
#> 4 PUBLIC_DISPATCHIS_202605030530_0000000515883691.zip
#> 5 PUBLIC_DISPATCHIS_202605030535_0000000515884165.zip
#> 6 PUBLIC_DISPATCHIS_202605030540_0000000515884588.zip
#>                       modified  size
#> 1 Sunday, May 3, 2026  5:10 AM 20392
#> 2 Sunday, May 3, 2026  5:15 AM 20317
#> 3 Sunday, May 3, 2026  5:20 AM 20328
#> 4 Sunday, May 3, 2026  5:25 AM 20305
#> 5 Sunday, May 3, 2026  5:30 AM 20290
#> 6 Sunday, May 3, 2026  5:35 AM 20293
#>                                                                                                           url
#> 1 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030515_0000000515882382.zip
#> 2 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030520_0000000515882783.zip
#> 3 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030525_0000000515883302.zip
#> 4 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030530_0000000515883691.zip
#> 5 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030535_0000000515884165.zip
#> 6 http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_DISPATCHIS_202605030540_0000000515884588.zip
options(op)
# }
```
