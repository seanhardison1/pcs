#' Parse rider profile information from HTML code
#'
#' \code{parse_rider_profile} parses HTML code of rider's profile page
#' for personal information.
#'
#' @param rider_html HTML code of rider's profile page
#' @return Rider profile information (see \code{rider_profiles_men} documentation)
parse_rider_profile <- function(rider_html)
{
  # Rider name
  rider_name<-
    rider_html %>%
    rvest::html_nodes('h1') %>%
    rvest::html_text() %>%
    stringr::str_split(.,"»")
  
  rider <- stringr::str_squish(rider_name[[1]][1])
  
  # Rider team
  team <- rider_html %>% 
    rvest::html_nodes(xpath = "/html/body/div[1]/div[1]/div[2]/div[1]/span[4]") %>% 
    rvest::html_text()
  
  jumbled <- rider_html %>%
    rvest::html_nodes(".rdr-info-cont") %>%
    rvest::html_text()
  
  if (stringr::str_detect(jumbled, "Date of birth:")){
    dob <- jumbled %>%
      gsub('^Date of birth: (\\w+ \\w+ \\w+) .+$', '\\1', .) %>%
      stringr::str_remove("th|nd|rd|st") %>%
      stringr::str_squish() %>%
      readr::parse_date(., format = "%d %B %Y")
  } else {
    dob <- NA
  }
  
  if (stringr::str_detect(jumbled, "Nationality")){
    nationality <- jumbled %>%
      stringr::str_extract("(?<=Nationality: )(.*)Weight") %>%
      stringr::str_remove("Weight$")
  } else {
    nationality <- NA
  }
  
  if (stringr::str_detect(jumbled, "Weight")){
    weight <- jumbled %>%
      stringr::str_extract("(?<=Weight: ).*(?= kg)")
  } else {
    weight <- NA
  }
  
  if (stringr::str_detect(jumbled, "Height")){
    height <- jumbled %>%
      stringr::str_extract("(?<=Height: ).*(?= m)")
  } else {
    height <- NA
  }
  
  if (stringr::str_detect(jumbled, "Place of birth:")){
    pob <- jumbled %>%
      stringr::str_extract("(?<=Place of birth: ).*(?=LIVE)|(?=Points)|(?=One)") %>%
      stringr::str_squish()
  } else {
    pob <- NA
  }
  
  one_day_races <- jumbled %>%
    stringr::str_extract("(?<=Points per specialty).*(?=One day races)")
  
  gc <- jumbled %>%
    stringr::str_extract("(?<=One day races\\n).*(?=GC)")
  
  tt <- jumbled %>%
    stringr::str_extract("(?<=GC\\n).*(?=Time trial)")
  
  sprint <- jumbled %>%
    stringr::str_extract("(?<=Time trial\\n).*(?=Sprint)")
  
  climber <- jumbled %>%
    stringr::str_extract("(?<=Sprint\\n).*(?=Climber)")
  
  out <- tibble(rider = rider,
                dob = dob,
                nationality = nationality,
                pob = pob,
                current_team = team,
                weight = as.numeric(weight),
                height = as.numeric(height),
                one_day_races = as.numeric(one_day_races),
                gc = as.numeric(gc),
                tt = as.numeric(tt),
                sprint = as.numeric(sprint),
                climber = as.numeric(climber))
  
  return(out)
}
