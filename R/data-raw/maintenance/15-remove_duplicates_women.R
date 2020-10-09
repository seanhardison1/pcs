library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")
source("R/data-raw/maintenance/pcs_fixing.R")

duplicates <- pcs::rider_records_women %>% find_duplicate_results()

# ******************************************************************************

# Step 0: Fix PCS errors
out <- fix_pcs_results_women(pcs::rider_records_women)


# Finally: Check & Export data
duplicates <- find_duplicate_results(out)
stopifnot(nrow(duplicates) == 0)

rider_records_women <- out

usethis::use_data(rider_records_women,
                  overwrite = TRUE)

write_csv(rider_records_women, here::here("data/rider_records_women.csv"))
