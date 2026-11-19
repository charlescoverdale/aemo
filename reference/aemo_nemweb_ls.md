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
#> 1 PUBLIC_DISPATCHIS_202611171835_0000000549110014.zip
#> 2 PUBLIC_DISPATCHIS_202611171840_0000000549110683.zip
#> 3 PUBLIC_DISPATCHIS_202611171845_0000000549111231.zip
#> 4 PUBLIC_DISPATCHIS_202611171850_0000000549111800.zip
#> 5 PUBLIC_DISPATCHIS_202611171855_0000000549112540.zip
#> 6 PUBLIC_DISPATCHIS_202611171900_0000000549113065.zip
#>                              modified  size
#> 1 Tuesday, November 17, 2026 06:30 PM 20183
#> 2 Tuesday, November 17, 2026 06:35 PM 20209
#> 3 Tuesday, November 17, 2026 06:40 PM 20101
#> 4 Tuesday, November 17, 2026 06:45 PM 20206
#> 5 Tuesday, November 17, 2026 06:50 PM 20104
#> 6 Tuesday, November 17, 2026 06:55 PM 20099
#>                                                                                                            url
#> 1 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171835_0000000549110014.zip
#> 2 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171840_0000000549110683.zip
#> 3 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171845_0000000549111231.zip
#> 4 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171850_0000000549111800.zip
#> 5 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171855_0000000549112540.zip
#> 6 https://nemweb.com.au/Reports/CURRENT/DispatchIS_Reports/PUBLIC_DISPATCHIS_202611171900_0000000549113065.zip
options(op)
# }
```
