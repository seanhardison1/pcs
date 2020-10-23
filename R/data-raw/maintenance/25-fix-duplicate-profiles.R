#
# This script should be run step by step (i.e. not sourced)
#


library(dplyr)
library(stringr)
library(xml2)
library(rvest)
library(tidyr)
library(readr)
library(httr)

source("R/data-raw/functions.R")

### Probably won't work on Windows!
Sys.setlocale("LC_TIME", "en_US.UTF-8")


count_unique_riders <- function(profiles)
{
  cnt <- profiles %>%
    group_by(rider, dob) %>%
    summarise() %>%
    nrow()
  return(cnt)
}


fix_duplicate_profiles <- function(profiles)
{
  dups <- find_duplicate_profiles(profiles)

  usr_agent <-
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/83.0.4103.61 Chrome/83.0.4103.61 Safari/537.36'

  h <- handle("https://www.procyclingstats.com/search.php")

  new <- NULL
  for (i in 1:nrow(dups))
  {
    rider <- dups[i, ]$rider
    message(rider)
    response <- GET(
      "https://www.procyclingstats.com/search.php",
      query = list("term" = rider),
      handle = h,
      user_agent(usr_agent)
    )
    message(response$status_code)

    div <- response %>% content() %>%
      html_nodes(xpath = "//div[@class='content ']")
    h3 <- div %>%
      html_nodes(xpath = "h3")

    if (length(h3) > 0 && html_text(h3) == "Search results")
    {
      rider_url <- div %>%
        html_nodes(xpath = "div[3]/a") %>%
        html_attr("href")
      response <- GET(
        paste0("https://www.procyclingstats.com/", rider_url),
        handle = h,
        user_agent(usr_agent)
      )
      message(response$status_code)

    }

    rider_profile <- parse_rider_profile(response %>% content())
    new <- rbind(new, rider_profile)

    Sys.sleep(4.444)
  }

  out <- consolidate_profiles(profiles, new)

  return (out)
}

message("Men profiles: ", count_unique_riders(pcs::rider_profiles_men))
rider_profiles_men <- fix_duplicate_profiles(pcs::rider_profiles_men)
message("Men profiles: ", count_unique_riders(rider_profiles_men))

message("Women profiles: ", count_unique_riders(pcs::rider_profiles_women))
rider_profiles_women <- fix_duplicate_profiles(pcs::rider_profiles_women)
message("Women profiles: ", count_unique_riders(pcs::rider_profiles_women))

usethis::use_data(rider_profiles_men,
                  rider_profiles_women,
                  overwrite = TRUE)

write_csv(rider_profiles_men, here::here("data/rider_profiles_men.csv"))
write_csv(rider_profiles_women, here::here("data/rider_profiles_women.csv"))
