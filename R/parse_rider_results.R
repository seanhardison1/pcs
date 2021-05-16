#' Parse rider results from HTML code
#'
#' \code{parse_rider_results} parses HTML code of rider's profile page
#' for race results.
#'
#' @param rider_id Rider's profile ID
#' @param rider_html HTML code of rider's profile page
#' @param seasons (optional) Vector of covered seasons (as integers), all if \code{NULL} (default)
#' @return Rider results (see \code{rider_records_men} documentation)
parse_rider_results <- function(rider_id, rider_html, seasons = NULL)
{
  rider_season_output <- NULL
  
  # Rider name
  rider_name<-
    rider_html %>%
    html_nodes('h1') %>%
    html_text() %>%
    str_split(.,"»")
  
  rider <- stringr::str_squish(rider_name[[1]][1])
  
  # Rider team
  team <- rider_html %>% 
    rvest::html_nodes(xpath = "/html/body/div[1]/div[1]/div[2]/div[1]/span[4]") %>% 
    rvest::html_text()
  
  # Extract number of seasons raced by rider
  seasonResults <- 
    rider_html %>% 
    rvest::html_nodes(xpath = "/html/body/div[1]/div[1]/div[7]/div[1]/div[4]/ul") %>% 
    rvest::html_nodes(".seasonResults") %>%
    rvest::html_text() %>%
    unique()
  
  # if the extract is length 0, then it's probably looking in the wrong place
  if(length(seasonResults) == 0)
  {
    seasonResults <- rider_html %>% 
      rvest::html_nodes(xpath = "/html/body/div[1]/div[1]/div[7]/div[1]/div[3]/ul") %>% 
      rvest::html_nodes(".seasonResults") %>%
      rvest::html_text() %>%
      unique()
  } 
  
  stopifnot(length(seasonResults) != 0)
  
  for (j in 1:length(seasonResults))
  {
    year <- seasonResults[j]
    if (!(is.null(seasons)) && !(year %in% seasons))
    {
      next
    }
    
    Sys.sleep(1)
    message(paste(rider, year))
    rider_season_url <- paste0(rider_id, "/", year)
    rider_season_site <- pcs:::read_html_safe(rider_season_url)
    rider_season_table <- rider_season_site %>%
      rvest::html_table() %>%
      .[[1]] %>% 
      dplyr::rename(gc_result_on_stage = 3,
                    e1 = 4,
                    e2 = 9) %>%
      dplyr::select(-e1,-e2)
    
    gt <- rider_season_table %>%
      dplyr::filter(case_when(str_detect(Date, "›") ~ T,
                       Date == "" ~ T,
                       stringr::str_detect(Race, "Stage") ~ T))
    
    if (nrow(gt) != 0){
      group_indices1 <- which(str_detect(gt$Date, "›"))
      group_indices2 <- c(diff(group_indices1)[1],
                          diff(group_indices1)[-1],
                          (nrow(gt) - group_indices1[length(group_indices1)] + 1))
      group_indices <- group_indices2[!is.na(group_indices2)]
      
      
      gt_init <- gt %>%
        dplyr::mutate(id = rep(1:length(group_indices),
                        times = group_indices)) %>%
        {. ->> gt_anti_join} %>%
        dplyr::group_by(id) %>%
        dplyr::mutate(stage = Race,
               Race = first(Race)) %>%
        dplyr::slice(-1) %>%
        dplyr::ungroup() %>%
        dplyr::select(-id)
      
      one_day_init <-
        rider_season_table %>%
        dplyr::filter(!Race %in% unique(gt_anti_join$Race)) %>%
        dplyr::mutate(stage = "One day")
      
      output <- bind_rows(one_day_init,
                          gt_init) %>%
        dplyr::mutate(Date = ifelse(Date != "", paste0(Date,".",year), "NA"),
               Date = parse_datetime(Date, format = "%d.%m.%Y"),
               rider = rider,
               team = team)
      
      # print(output)
    } else {
      output <-
        rider_season_table %>%
        dplyr::mutate(Date = ifelse(Date != "", paste0(Date,".",year), "NA"),
               Date = parse_datetime(Date, format = "%d.%m.%Y"),
               stage = "One day",
               rider  = rider,
               team = team)
    }
    assign('rider_season_output', rbind(rider_season_output, output))
  }
  
  rider_records <- tibble::tibble(rider_season_output) %>%
    dplyr::mutate(Result = as.numeric(str_replace_all(Result, c("DNF" = "999", "DNS" = "998",
                                                         "OTL" = "997", "DF" = "996",
                                                         "NQ" = "995", "DSQ" = "994"))))
  names(rider_records) <- str_to_lower(names(rider_records))
  
  return(rider_records)
}
