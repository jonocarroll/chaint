say <- function(.data, .message) {
  message(.message)
  return(.data)
}

tee <- function(.data, .message, .expr, ...) {
  message(.message)
  print(do.call(.expr, list(.data, ...)))
  return(.data)
}
