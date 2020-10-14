library(dplyr)
library(stringr)
library(xml2)
library(rvest)
library(tidyr)
library(readr)

source("R/data-raw/functions.R")
source("R/data-raw/maintenance/pcs_fixing.R")

p1 <- fix_pcs_results_women(pcs::rider_records_women)

# are we good?
test <- find_duplicate_results(p1)
stopifnot(nrow(test) == 0)

pcs_data <- get_pcs_data(c('hannah-barnes'))
p2 <- pcs_data$results %>%
  mutate(dup = "new data")

# 75th place
subset(p1, date == '2016-10-15' &
         rider == 'Hannah Barnes')
# 76th place
subset(p2, date == '2016-10-15')
