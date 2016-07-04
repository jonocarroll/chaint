
#' Interject a Message within a magrittr/dplyr Chain
#'
#' @param .data the lhs of the chain evaluation
#' @param .message a message to be output to the console
#'
#' @return outputs the incomming data transparently
#' 
#' @export
say <- function(.data, .message) {
  message(.message)
  return(.data)
}

#' tee Function within a magrittr/dplyr Chain
#'
#' @param .data the lhs of the chain evaluation
#' @param .message a message to be output to the console
#' @param .expr expression to be evaluated
#' @param ... named arguments to pass to the evalutating function
#'
#' @return outputs the incomming data transparently
#' 
#' @export
tee <- function(.data, .message, .expr, ...) {
  message(.message)
  print(do.call(.expr, list(.data, ...)))
  return(.data)
}
