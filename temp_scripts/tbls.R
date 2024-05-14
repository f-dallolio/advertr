library(helprs)
library(tidyverse)
library(advertr)
library(fs)
library(arrow)

dir <- "/mnt/sata_data_1/adintel_parquet/year_files/"
paths <- dir_ls(dir, recurse = TRUE, type = "file")

tictoc::tic()
df <- paths |>
  path_common_remove(dir = TRUE) |>
  path_split() |>
  list_transpose() |>
  setNames(c("year", "type", "file")) |>
  map(type.convert, as.is = TRUE) |>
  as_tibble() |>
  mutate(path = path_dir(paths)) |>
  mutate(tbl = map(path, arrow::open_dataset),
         .before = path) |>
  mutate(nrows = map_int(tbl, nrow),
         ncols = map_int(tbl, ncol),
         col_names = map(tbl, names),
         col_types = map(tbl, get_cols_call),
         .before = tbl) |>
  mutate(file = str_replace_all(file, "NetworkTV", "NationalTV"))
# |>
#   mutate(splitter = paste("year", year, sep = "_")) |>
#   nest(.by = splitter) |>
  # deframe()
tictoc::toc()

df$path

df |>
  filter(type == "Occurrences",
         file |> str_detect("TV")) |>
  select(path) |>
  write_csv("temp_files/tv_paths.csv")

tictoc::tic()
x |> group_by(MediaTypeID, AdDate) |>
  write_dataset("temp_files/test")
tictoc::toc()
