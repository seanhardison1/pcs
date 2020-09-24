library(dplyr)
library(stringr)
library(xml2)
library(rvest)
library(tidyr)
library(readr)

source("R/data-raw/functions.R")


# Get URL of latest rankings
rankings_url <- get_ranking_url("https://www.procyclingstats.com/rankings.php/me?cat=me")
# Get URL of rider profiles
rider_urls <- get_rider_urls(rankings_url)
# Get profiles and results for each rider
pcs_data <- get_pcs_data(rider_urls)

# Use distinct profiles only
rider_profiles_men <-
  pcs::rider_profiles_men %>%
  full_join(., pcs_data$profiles) %>%
  distinct()

# Use distinct records only
rider_records_men <-
  pcs::rider_records_men %>%
  full_join(., pcs_data$results) %>%
  distinct()

#
# Same for women elite
#
rankings_url <- get_ranking_url("https://www.procyclingstats.com/rankings.php/we?cat=we")
rider_urls <- get_rider_urls(rankings_url)
pcs_data <- get_pcs_data(rider_urls)

rider_profiles_women <-
  pcs::rider_profiles_women %>%
  full_join(., pcs_data$profiles) %>%
  distinct()

rider_records_women <-
  pcs::rider_records_women %>%
  full_join(., pcs_data$results) %>%
  distinct()

# Export
usethis::use_data(rider_profiles_men,
                  rider_records_men,
                  rider_profiles_women,
                  rider_records_women,
                  overwrite = TRUE)

write_csv(rider_profiles_men, here::here("data/rider_profiles_men.csv"))
write_csv(rider_profiles_women, here::here("data/rider_profiles_women.csv"))
write_csv(rider_records_men, here::here("data/rider_records_men.csv"))
write_csv(rider_records_women, here::here("data/rider_records_women.csv"))
