#' Main PCS scraping function
#' 
#' \code{query_pcs} scrapes PCS data (rider profiles and results)
#' for a given vector of rider names. 
#' 
#' @param rider_names Character vector containing one or more rider names.
#' @param seasons Integer vector of years ("seasons") to collect results from. Will return all years if \code{NULL}.
#' @return List of two data frames (\code{profiles} and \code{results}).
#' 
#' The \code{results} data frame contains the following:
#' 
#' \itemize{
#'     \item date: Date of race.
#'     \item result: Race result.
#'     \item gc_result_on_stage: If a race was a stage race, gives the rider's placement overall following the stage.
#'     \item race: Race name.
#'     \item distance: Race distance (km).
#'     \item pointspcs: PCS points awarded.
#'     \item pointsuci: UCI points awarded.
#'     \item stage: Type of race (one day, stage race, etc).
#'     \item rider: Rider name.
#'     \item team: Team name.
#' }
#'
#' The \code{profiles} data frame contains the following:
#' 
#' \itemize{
#'     \item rider: Rider name.
#'     \item dob: Date of birth.
#'     \item Nationality
#'     \item pob: Place of birth.
#'     \item current_team: Current team.
#'     \item weight: Weight in kg.
#'     \item height: Height in m.
#'     \item one_day_races: Career points awarded for success in one day races.
#'     \item gc: Career points awarded for success in grand tours.
#'     \item tt: Career points awarded for success in time trials.
#'     \item sprint: Career points awarded for success in sprint-focused races.
#'     \item climber: Career points awarded for success in climbing-focused races.
#' }
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
  rider_urls <- pcs:::name_fixer(rider_names)
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

