#' Get HTML document represented by URL
#'
#' \code{read_html_safe} downloads HTML document from URL address. Function
#' \code{xml2::read_html} is called. When HTTP error occurs, optional \code{tries}
#' parameter is decreased and new attempt is performed until \code{tries} counter
#' reaches zero.
#'
#' @param url URL of web page to be downloaded
#' @param tries Retry counter (optional, default = 3)
#' @return HTML document, NULL on error
#' 
#' 
read_html_safe <- function(url, tries = 3)
{
  res_html <- NULL
  while (tries > 0 && is.null(res_html))
  {
    tryCatch(
      {
        res_html <- read_html(url)
        break()
      },
      error = function(e)
      {
        message(paste(e, url))
      })
    tries <- tries - 1
  }
  
  return(res_html)
}
