library(dplyr)
library(stringr)
library(rvest)
library(xml2)
library(tidyr)
library(readr)


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


#' Get URL of latest PCS ranking
#'
#' \code{get_ranking_url} parses "rankings" page and returns URL to
#' latest rankings set.
#' 
#' @param url PCS rankings URL, e.g.:
#'   "https://www.procyclingstats.com/rankings.php/me?cat=me" (men elite)
#'   "https://www.procyclingstats.com/rankings.php/we?cat=we" (women elite)
#' @return URL to latest rankings set
get_ranking_url <- function(url)
{
  site <- read_html_safe(url)

  rankings_id <-
    site %>%
    html_nodes(xpath = "//div[@class='content ']") %>%
    html_nodes(xpath = "//div[@class='statDivLeft']") %>%
    html_nodes(xpath = "//form[@action='rankings.php']") %>%
    html_nodes(xpath = "//select[@name='id']/option[@selected]") %>%
    xml_attr("value")

  rankings_url <- "https://www.procyclingstats.com/rankings.php?id=%s&nation=&team=&page=0&prev_id=prev&younger=&older=&limit=200&filter=Filter&morefilters="
  return(sprintf(rankings_url, rankings_id))
}


#' Get riders profile IDs from *ranking* page
#' 
#' \code{get_rider_urls} parses ranking page and returns
#' vector of rider profiles IDs.
#' 
#' @param url Ranking URL (obtained from \code{get_ranking_url})
#' @return Vector of rider profiles IDs for each rider
get_rider_urls <- function(url)
{
  site <- read_html_safe(url)
  current_rankings <-
    site %>%
    html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "statDivLeft", " " ))]') %>%
    html_nodes("table") %>%
    {. ->> raw_table} %>%
    .[[1]] %>%
    html_table() %>%
    dplyr::select(-7) %>%
    mutate(`Diff.` = as.numeric(ifelse(str_detect(`Diff.`,"\\u25B2"),
                                       str_remove(`Diff.`, "\\u25B2"),
                                       ifelse(str_detect(`Diff.`,"\\u25BC"),
                                              str_replace(`Diff.`, "\\u25BC","-"),
                                              ifelse(str_detect(`Diff.`,"-"),
                                                     0,
                                                     `Diff.`)))))


  url_list <- raw_table %>%
    html_nodes(., "a") %>%
    html_attr(., "href") %>%
    as_tibble() %>%
    filter(str_detect(value, "rider/|team/")) %>%
    separate(value, c("var","url"), "/")

  rider_urls <- url_list %>%
    filter(var == "rider") %>%
    dplyr::pull(url)

  return(rider_urls)
}


#' Get riders profile IDs from *startlist* page
#' 
#' \code{get_rider_urls_sl} parses startlist page and returns
#' vector of rider profiles IDs.
#' 
#' @param url Startlist URL, e.g.:
#'   "https://www.procyclingstats.com/race/tour-de-france/2020/gc/startlist"
#' @return Vector of rider profiles IDs for each rider
get_rider_urls_sl <- function(url)
{
  site <- read_html_safe(url)

  rider_urls <- site %>%
    html_nodes(xpath = "//ul[@class='startlist']") %>%
    html_nodes(xpath = "//a[@class='rider blue ']") %>%
    xml_attr("href") %>%
    str_remove("^rider/")

  return(rider_urls)
}


#' Parse rider profile information from HTML code
#'
#' \code{parse_rider_profile} parses HTML code of rider's profile page
#' for personal information.
#'
#' @param rider_html HTML code of rider's profile page
#' @return Rider profile information (see \code{rider_profiles_men} documentation)
parse_rider_profile <- function(rider_html)
{
  rider_metadata<-
    rider_html %>%
    html_nodes('h1') %>%
    html_text() %>%
    str_split(.,"»")

  rider <- str_squish(rider_metadata[[1]][1])
  team <- str_squish(rider_metadata[[1]][2])

  jumbled <- rider_html %>%
    html_nodes(".rdr-info-cont") %>%
    html_text()

  if (str_detect(jumbled, "Date of birth:")){
    dob <- jumbled %>%
      str_extract("(?<=:).*(?=\\()") %>%
      str_remove("th|nd|rd|st") %>%
      str_squish() %>%
      as.Date(., format = "%d %B %Y")
  } else {
    dob <- NA
  }

  if (str_detect(jumbled, "Nationality")){
    nationality <- jumbled %>%
      str_extract("(?<=Nationality: )([A-Z][a-z]*)")
  } else {
    nationality <- NA
  }

  if (str_detect(jumbled, "Weight")){
    weight <- jumbled %>%
      str_extract("(?<=Weight: ).*(?= kg)")
  } else {
    weight <- NA
  }

  if (str_detect(jumbled, "Height")){
    height <- jumbled %>%
      str_extract("(?<=Height: ).*(?= m)")
  } else {
    height <- NA
  }

  if (str_detect(jumbled, "Place of birth:")){
    pob <- jumbled %>%
      str_extract("(?<=Place of birth: ).*(?=Points)|(?=One)") %>%
      str_squish()
  } else {
    pob <- NA
  }

  one_day_races <- jumbled %>%
    str_extract("(?<=Points per specialty).*(?=One day races)")

  gc <- jumbled %>%
    str_extract("(?<=One day races).*(?=GC)")

  tt <- jumbled %>%
    str_extract("(?<=GC).*(?=Time trial)")

  sprint <- jumbled %>%
    str_extract("(?<=Time trial).*(?=Sprint)")

  climber <- jumbled %>%
    str_extract("(?<=Sprint).*(?=Climber)")

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


#' Parse rider results from HTML code
#'
#' \code{parse_rider_results} parses HTML code of rider's profile page
#' for race results.
#'
#' @param rider_id Rider's profile ID
#' @param rider_html HTML code of rider's profile page
#' @return Rider results (see \code{rider_records_men} documentation)
parse_rider_results <- function(rider_id, rider_html)
{
  rider_season_output <- NULL

  rider_metadata <-
    rider_html %>%
    html_nodes('h1') %>%
    html_text() %>%
    str_split(.,"»")

  rider <- str_squish(rider_metadata[[1]][1])
  team <- str_squish(rider_metadata[[1]][2])


  seasons <- rider_html %>%
    html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "minh2", " " ))]') %>%
    html_nodes(".seasonResults") %>%
    html_text() %>%
    unique()
  
  if(length(seasons) == 0){
    seasons <- rider_html %>%
      html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "content", " " ))]') %>% html_nodes(".seasonResults") %>%
      html_text() %>%
      unique()
  }

  for (j in 1:length(seasons))
  {
    Sys.sleep(1)
    message(paste(rider, seasons[j]))
    rider_season_url <- paste0(rider_id, "/", seasons[j])
    rider_season_site <- read_html_safe(rider_season_url)
    rider_season_table <- rider_season_site %>%
      html_nodes("table") %>%
      .[[1]] %>%
      html_table() %>%
      dplyr::rename(gc_result_on_stage = 3,
                    e1 = 4,
                    e2 = 9) %>%
      dplyr::select(-e1,-e2)

    gt <- rider_season_table %>%
      filter(case_when(str_detect(Date, "›") ~ T,
                       Date == "" ~ T,
                       str_detect(Race, "Stage") ~ T))

    if (nrow(gt) != 0){
      group_indices1 <- which(str_detect(gt$Date, "›"))
      group_indices2 <- c(diff(group_indices1)[1],
                          diff(group_indices1)[-1],
                          (nrow(gt) - group_indices1[length(group_indices1)] + 1))
      group_indices <- group_indices2[!is.na(group_indices2)]


      gt_init <- gt %>%
        mutate(id = rep(1:length(group_indices),
                        times = group_indices)) %>%
        {. ->> gt_anti_join} %>%
        group_by(id) %>%
        mutate(stage = Race,
               Race = first(Race)) %>%
        slice(-1) %>%
        ungroup() %>%
        dplyr::select(-id)

      one_day_init <-
        rider_season_table %>%
        filter(!Race %in% unique(gt_anti_join$Race)) %>%
        mutate(stage = "One day")

      output <- bind_rows(one_day_init,
                          gt_init) %>%
        mutate(Date = ifelse(Date != "",paste0(Date,".",seasons[j]),NA),
               Date = as.Date(Date, "%d.%m.%Y"),
               rider = rider,
               team = team)
    } else {
      output <-
        rider_season_table %>%
        mutate(Date = ifelse(Date != "",paste0(Date,".",seasons[j]),NA),
               Date = as.Date(Date, "%d.%m.%Y"),
               stage = "One day",
               rider  = rider,
               team = team)
    }
    assign('rider_season_output', rbind(rider_season_output, output))
  }

  rider_records <- tibble(rider_season_output) %>%
    mutate(Result = as.numeric(str_replace_all(Result, c("DNF" = "999", "DNS" = "998",
                                                         "OTL" = "997", "DF" = "996",
                                                         "NQ" = "995", "DSQ" = "994"))))
  names(rider_records) <- str_to_lower(names(rider_records))

  return(rider_records)
}


#' Main PCS scraping function
#' 
#' \code{get_pcs_data} scrapes PCS data (rider profiles and results)
#' for given vector of rider IDs.
#' 
#' @param rider_urls Vector of rider's profile IDs
#' @return List of two data frames (\code{profiles} and \code{results}).
#'   See \code{rider_profiles_men} and \code{rider_records_men} documentation
#'   for details.
get_pcs_data <- function(rider_urls)
{
  rider_profiles <- NULL
  rider_results <- NULL
  for (i in 1:length(rider_urls))
  {
    Sys.sleep(1)
    rider_url <- paste0("https://www.procyclingstats.com/rider/",rider_urls[i])
    rider_html <- read_html_safe(rider_url)
    
    profile_out <- parse_rider_profile(rider_html)
    message(profile_out["rider"])
    assign('rider_profiles', rbind(profile_out, rider_profiles))
    
    results_out <- parse_rider_results(rider_url, rider_html)
    assign('rider_results', rbind(results_out, rider_results))
  }
  return(list("profiles" = rider_profiles,
              "results" = rider_results))
}
