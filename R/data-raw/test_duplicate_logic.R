library(dplyr)
library(stringr)
library(xml2)
library(rvest)
library(tidyr)
library(readr)

source("R/data-raw/functions.R")
source("R/data-raw/maintenance/pcs_fixing.R")

# Fix known problems in existing data
p1 <- fix_pcs_results_women(pcs::rider_records_women)

# are we good?
test <- find_duplicate_results(p1)
stopifnot(nrow(test) == 0)

# scrape women results
rankings_url <- get_ranking_url("https://www.procyclingstats.com/rankings.php/we?cat=we")
rider_urls <- get_rider_urls(rankings_url)
pcs_data <- get_pcs_data(rider_urls)

# Fix known problems in new data
p2 <- fix_pcs_results_women(pcs_data$results)

###
## Actual "duplicate logic" code
## p1: existing data (PCS errors fixed)
## p2: latest data (PCS errors fixed)

out <- full_join(p1, p2)
dups <- find_duplicate_results(out)

# remove every duplicate record from p1
tp1 <- anti_join(p1, dups, by = c("rider", "date", "race", "stage"))
# join with latest data
out <- full_join(tp1, p2)

# are we good?
test <- find_duplicate_results(out)
stopifnot(nrow(test) == 0)
