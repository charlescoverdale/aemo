# Download a NEMweb zipped CSV to the local cache

Thin wrapper over the internal cache-aware downloader.

## Usage

``` r
aemo_nemweb_download(url, cache = TRUE)
```

## Arguments

- url:

  A fully-qualified NEMweb URL (zipped CSV).

- cache:

  Logical. Reuse cached file if present.

## Value

Path to the cached file.

## See also

Other low-level:
[`aemo_nemweb_ls()`](https://charlescoverdale.github.io/aemo/reference/aemo_nemweb_ls.md)

## Examples

``` r
# \donttest{
op <- options(aemo.cache_dir = tempdir())
try({
  files <- aemo_nemweb_ls("/Reports/Current/DispatchIS_Reports/")
  if (nrow(files) > 0) {
    f <- aemo_nemweb_download(files$url[1])
    file.exists(f)
  }
})
#> ℹ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> ✔ Downloading <http://nemweb.com.au/Reports/Current/DispatchIS_Reports/PUBLIC_D…
#> 
#> [1] TRUE
options(op)
# }
```
