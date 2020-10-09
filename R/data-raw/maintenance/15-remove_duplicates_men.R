library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")
source("R/data-raw/maintenance/functions.R")

duplicates <- pcs::rider_records_men %>% find_duplicate_results()

# ******************************************************************************

# Step 0: Fix PCS errors
out <- fix_pcs_results_men(pcs::rider_records_men)

# Step 1:
before <- nrow(out)

out <- out[!(out$date == '2010-08-10' &
               out$race == 'Oslo Grand Prix (Nat.)' &
               out$rider == 'Richie Porte' &
               is.na(out$distance)),]

after <- nrow(out)
stopifnot(before - after == 1)


# Step 2:
before <- nrow(out)

brx <- out %>%
  subset(out$date == '2020-08-30' &
           out$race == 'Brussels Cycling Classic (1.Pro)')

old <- brx %>% subset(brx$distance == 203.7)
new <- brx %>% subset(brx$distance == 204)

out <- anti_join(out,
                 subset(old, old$rider %in% new$rider))

after <- nrow(out)
stopifnot(before - after == 8)

# Step 3:
before <- nrow(out)

tdf <- subset(out,
              out$date == '2020-08-30' &
                out$race == 'Tour de France (2.UWT)' &
                out$stage == 'Stage 2 - Nice › Nice')

old <- tdf %>% subset(tdf$distance == 186)
new <- tdf %>% subset(tdf$distance == 185)

out <- anti_join(out,
                 subset(old, old$rider %in% new$rider))

after <- nrow(out)
stopifnot(before - after == 56)


# Finally: Check & Export data
duplicates <- find_duplicate_results(out)
stopifnot(nrow(duplicates) == 0)

rider_records_men <- out

usethis::use_data(rider_records_men,
                  overwrite = TRUE)

write_csv(rider_records_men, here::here("data/rider_records_men.csv"))
