library(dplyr)
library(stringr)
library(here)
library(readr)

#
# Men
#
rider_profiles_men <- pcs::rider_profiles_men %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("Czech"),
                  "Czech Republic")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("Great"),
                  "Great Britain")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("New"),
                  "New Zealand")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("United"),
                  "United States"))

usethis::use_data(rider_profiles_men,
                  overwrite = TRUE)

write_csv(rider_profiles_men, here::here("data/rider_profiles_men.csv"))

# check <- rider_profiles_men %>%
#   group_by(nationality) %>%
#   summarise()


#
# Women
#
rider_profiles_women <- pcs::rider_profiles_women %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("Czech"),
                  "Czech Republic")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("Great"),
                  "Great Britain")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("New"),
                  "New Zealand")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("South"),
                  "South Africa")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("Trinidad"),
                  "Trinidad & Tobago")) %>%
  mutate(
    nationality =
      str_replace(nationality,
                  fixed("United"),
                  "United States"))

usethis::use_data(rider_profiles_women,
                  overwrite = TRUE)

write_csv(rider_profiles_women, here::here("data/rider_profiles_women.csv"))
