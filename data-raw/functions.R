library(xml2)

read_html_safe <- function(url, tries = 3)
{
  res_html <- NULL
  while (tries > 0 & is.null(res_html))
  {
    tryCatch(
      {
        res_html <- read_html(url)
        break()
      }
      ,
      error = function(e)
      {
        message(paste(e, url))
      }
    )
    tries <- tries - 1
  }

  return(res_html)
}
