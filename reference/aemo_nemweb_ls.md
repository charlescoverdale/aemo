# List files in a NEMweb directory

Returns a data frame of files in a NEMweb path, parsed from the Apache
directory-listing HTML.

## Usage

``` r
aemo_nemweb_ls(path)
```

## Source

AEMO NEMweb
<https://www.aemo.com.au/energy-systems/electricity/national-electricity-market-nem/data-nem/market-data-nemweb>,
published under the AEMO Copyright Permissions Notice.

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
#> 1 PUBLIC_DISPATCHIS_202611181850_0000000549289061.zip
#> 2 PUBLIC_DISPATCHIS_202611181855_0000000549289842.zip
#> 3 PUBLIC_DISPATCHIS_202611181900_0000000549290399.zip
#> 4 PUBLIC_DISPATCHIS_202611181905_0000000549291068.zip
#> 5 PUBLIC_DISPATCHIS_202611181910_0000000549291744.zip
#> 6 PUBLIC_DISPATCHIS_202611181915_0000000549292353.zip
#>                                modified  size
#> 1 Wednesday, November 18, 2026 06:45 PM 20471
#> 2 Wednesday, November 18, 2026 06:50 PM 20363
#> 3 Wednesday, November 18, 2026 06:55 PM 20322
#> 4 Wednesday, November 18, 2026 07:00 PM 20163
#> 5 Wednesday, November 18, 2026 07:05 PM 20216
#> 6 Wednesday, November 18, 2026 07:10 PM 19752
#>                                                                                                            url
#> 1 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181850_0000000549289061.zip
#> 2 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181855_0000000549289842.zip
#> 3 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181900_0000000549290399.zip
#> 4 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181905_0000000549291068.zip
#> 5 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181910_0000000549291744.zip
#> 6 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611181915_0000000549292353.zip
options(op)
# }
```
