dir <- "/mnt/sata_data_1/adintel_parquet/year_files/"
paths <- dir_ls(dir, recurse = TRUE, type = "file")

library(tidyverse)

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
  mutate(splitter = paste("year", year, sep = "_")) |>
  nest(.by = splitter) |>
  deframe()


purrr::list_rbind(df) |> mutate(file = file |> str_replace_all("NetworkTV", "NationalTV"))

x <- df[[1]] |>
  filter(type == "Occurrences",
         file |> str_detect("SpotTV")) |>
  # pluck("nrows")
  pluck("tbl", 1)


x |> group_by(MediaTypeID, AdDate) |>
  write_dataset("temp_scripts/test")



arrow::wr

x |>
  group_by(MediaTypeID) |>
  summarise(n = n()) |>
  collect()

.Last.value$n |> sum()
n
  collect()
  mutate(rows = nrow())
  summarise(n = max(seq_along(MediaTypeID))) |>
  collect()
