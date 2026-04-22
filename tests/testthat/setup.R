aemo_tmp <- tempfile("aemo_cache_")
dir.create(aemo_tmp, recursive = TRUE, showWarnings = FALSE)
options(aemo.cache_dir = aemo_tmp)
