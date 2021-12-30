#' Convert name inputs into working URL paths
#' 
#' @param x Name to convert
#' 
name_fixer <- function(x){
  stringr::str_replace_all(
    stringr::str_trim(
      stringr::str_to_lower(
        stringi::stri_trans_general(
          x,
          id = "Latin-ASCII"
        )
      )
    ), " |'", "-"
  )
}
