#' Parse team members from HTML
#'
#' \code{parse_team} parses queries https://www.procyclingstats.com/teams.php and extracts
#' team members
#'
#' @param team_url team name
#' @return A tibble containing team member names 

parse_team <- function(team_url, team){

  # query pcs
  team_html <- pcs:::read_html_safe(team_url)
  
  # parse html
  out <- 
    team_html %>% 
    rvest::html_nodes(xpath = '/html/body/div[1]/div[1]/div[7]/div[1]/div/div[2]/div[4]/ul/li/div[2]') %>% 
    rvest::html_children() %>% 
    rvest::html_text() %>%
    tibble::as_tibble() %>% 
    dplyr::filter(value != "") %>% 
    tidyr::separate(., col = value, into = c("last","last2","first"),
                    sep = "-| ") %>% 
    dplyr::mutate(team_members = stringr::str_to_lower(
      (ifelse(!is.na(first),
              paste(first, last, last2),
              ifelse(is.na(first),
                     paste(last2, last),
                     NA)))),
      team = team)  %>% 
    dplyr::select(team_members, team) %>% 
    suppressWarnings()
  return(out)
}
