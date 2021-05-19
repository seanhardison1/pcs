#' Query team membership
#' 
#' A function to query current pro team membership from PCS.
#' 
#' @param team_names Team name(s) as character vector.
#' 
#' @details This function is useful to generate a vector of names to use with
#' \code{query_pcs}. Only works for UCI WorldTeams and ProTeams that exist in the
#' current year.
#' 
#' @return A tibble containing rider and team names.
#' 
#' @export
#' 
#' @examples 
#' 
#' query_team(team_names = c("AG2R Citroen Team","Burgos-BH"))
query_team <- function(team_names){
  
  # turn team name into url path that will work with PCS
  teams <- paste(pcs:::name_fixer(team_names), 
                     stringr::str_extract(Sys.Date(), "\\d{4}"), sep = "-")
  
  team_output <- NULL
  for (i in 1:length(teams)){
    team_url <- paste0("https://www.procyclingstats.com/team/",teams[i])
    assign('team_output',rbind(team_output,parse_team(team_url, team = teams[i])))
  }
  return(team_output)
}



