library(dplyr)
library(rvest)
library(xml2)
library(stringr)
library(tidyr)

url <- "https://www.procyclingstats.com/rankings.php?id=59786&nation=&team=&page=0&prev_id=prev&younger=&older=&limit=200&filter=Filter&morefilters="
site <- read_html(url)

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
  tibble::as_tibble() %>% 
  filter(str_detect(value, "rider/|team/")) %>% 
  separate(value, c("var","url"), "/")

rider_urls <- url_list %>% 
  filter(var == "rider") %>% 
  dplyr::pull(url)

team_urls <- url_list %>% 
  filter(var ==  "team") %>% 
  dplyr::select(url) %>% 
  distinct()

rider_season_output <- NULL
for (i in 1:length(rider_urls)){
 url <- paste0("https://www.procyclingstats.com/rider/",rider_urls[i])
 rider_html <- read_html(url) 
  
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
 
 for (j in 1:length(seasons)){
 
   message(paste(rider, seasons[j]))
   rider_season_url <- paste0(url, "/", seasons[j])
   rider_season_site <- read_html(rider_season_url)
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
   
}

rider_records_men <- tibble(rider_season_output) %>% 
  mutate(result = as.numeric(str_replace_all(result, c("DNF" = "999", "DNS" = "998",
                                                     "OTL" = "997", "DF" = "996",
                                                     "NQ" = "995", "DSQ" = "994"))))

names(rider_records_men) <- str_to_lower(names(rider_records_men))

usethis::use_data(rider_records_men, overwrite = TRUE)

write_csv(rider_records_men,here::here("data/rider_records_men.csv"))
