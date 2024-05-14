# get_cols_call -----

#' Get column definitions
#'
#' @param x an objectg of class `Field`, `Schema`, `Dataset`, or `data.frame`.
#' @param to_str logical. If `TRUE` (default), `get_cols_call()` returns a string instead of a call.
#'
#' @return a list or a character vector.
#' @name get_cols_call
NULL
#' @rdname get_cols_call
#' @export
get_cols_call <- function(x, to_str = TRUE){
  UseMethod("get_cols_call")
}
#' @rdname get_cols_call
#' @export
get_cols_call.Field <- function(x, to_str = TRUE){
  x <- as_data_type(x)
  out <- x$code()
  if(to_str){
    lang_to_str(out)
  } else {
    out
  }
}
#' @rdname get_cols_call
#' @export
get_cols_call.Schema <- function(x, to_str = TRUE){
  nms <- names(x)
  lst <- as.list(x)
  names(lst) <- nms
  if(to_str){
    map_chr(lst, get_cols_call.Field)
  } else {
    map(lst, get_cols_call.Field, to_str = FALSE)
  }
}
#' @rdname get_cols_call
#' @export
get_cols_call.Dataset <- function(x, to_str = TRUE){
  x <- schema(x)
  get_cols_call.Schema(x, to_str = to_str)
}
#' @rdname get_cols_call
#' @export
get_cols_call.data.frame <- function(x, to_str = TRUE){
  x <- schema(x)
  get_cols_call.Schema(x, to_str = to_str)
}

# get_cols_type -----

#' Get column definitions
#'
#' @param x an object of class `Field`, `Schema`, `Dataset`, or `data.frame`.
#'
#' @return a list of Arrow data types.
#' @name get_cols_type
NULL
#' @rdname get_cols_type
#' @export
get_cols_type <- function(x){
  UseMethod("get_cols_type")
}
#' @rdname get_cols_type
#' @export
get_cols_type.Field <- function(x){
  x <- as_data_type(x)
}
#' @rdname get_cols_type
#' @export
get_cols_type.Schema <- function(x){
  nms <- names(x)
  lst <- as.list(x)
  names(lst) <- nms
  map(lst, as_data_type)
}
#' @rdname get_cols_type
#' @export
get_cols_type.Dataset <- function(x){
  x <- schema(x)
  get_cols_type.Schema(x)
}
#' @rdname get_cols_type
#' @export
get_cols_type.data.frame <- function(x){
  x <- schema(x)
  get_cols_type.Schema(x)
}
