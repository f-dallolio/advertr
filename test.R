library(helprs)
library(tidyverse)
library(advertr)
library(fs)
library(arrow)

ff <- function(path, out){
  open_dataset(path) |>
    group_by(MediaTypeID, AdDate) |>
    write_dataset(out)
}

paths <- read_csv("~/Documents/pkg_dev/advertr/temp_files/tv_paths.csv")[[1]][1:2]
out_paths <- fs::path("~/Documents/pkg_dev/advertr/temp_files", fs::path_file(paths))

purrr::walk2(paths, out_paths, ff)


