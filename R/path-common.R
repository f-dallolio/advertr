#' Detect or remove common path parts
#'
#' @param x a vector of paths.
#' @param negate logical. If `TRUE` the common part of the paths is removed. If `FALSE` (default), it is equivalent to `fs::patch_common()`.
#' @param dir logical. It applies `fs::path_dir()`.
#'
#' @return a vector of paths
#' @name path-common
NULL
#' @rdname path-common
#' @export
path_common2 <- function(x, negate = FALSE, dir = FALSE){
  if(dir){
    x <- fs::path_dir(x)
  }
  out <- fs::path_common(x)
  if(negate){
    out0 <- stringr::str_remove_all(x, paste0(out, "/"))
    out <- purrr::map_vec(unique(out0), path)
  }
  out
}
#' @rdname path-common
#' @export
path_common_remove <- function(x, dir = FALSE){
  path_common2(x, negate = TRUE, dir = dir)
}
