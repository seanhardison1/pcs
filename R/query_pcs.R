#' Main PCS scraping function
#' 
#' \code{query_pcs} scrapes PCS data (rider profiles and results)
#' for a given vector of rider names. 
#' 
#' @param rider_urls Character vector containing one or more rider names.
#' @param seasons Integer vector of years ("seasons") to collect results from. Will return all years if \code{NULL}.
#' @return List of two data frames (\code{profiles} and \code{results}).
#'   See \code{rider_profiles_men} and \code{rider_records_men} documentation
#'   for details.
#'   
#' @export query_pcs
#' 
#' @examples 
#' 
#' # race results for two riders in the 2021 season
#' query_pcs(c("Peter Sagan","Adam Yates"), seasons = 2021)
#' 
#' # two riders, two seasons
#' query_pcs(c("Peter Sagan","Adam Yates"), seasons = c(2020,2021))
#' 
#' # two riders, all seasons
#' query_pcs(c("Peter Sagan","Adam Yates"))
query_pcs <- function(rider_names, seasons = NULL)
{
  rider_urls <- name_fixer(rider_names)
  rider_profiles <- NULL
  rider_results <- NULL
  for (i in 1:length(rider_urls))
  {
    rider_url <- paste0("https://www.procyclingstats.com/rider/",rider_urls[i])
    rider_html <- pcs:::read_html_safe(rider_url)
    
    profile_out <- pcs:::parse_rider_profile(rider_html)
    message(profile_out["rider"])
    assign('rider_profiles', rbind(profile_out, rider_profiles))
    
    results_out <- pcs:::parse_rider_results(rider_url, rider_html, seasons)
    assign('rider_results', rbind(results_out, rider_results))
  }
  return(list("profiles" = rider_profiles,
              "results" = rider_results))
}

name_fixer <- function(x){
  stringr::str_replace_all(
    stringr::str_trim(
      stringr::str_to_lower(
        stringi::stri_trans_general(
          x,
          id = "Latin-ASCII"
        )
      )
    ), " ", "-"
  )
}

