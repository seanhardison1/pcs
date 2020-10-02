library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")

duplicates <- pcs::rider_records_women %>% findDuplicateResults()

# ******************************************************************************

out <- pcs::rider_records_women


# Step 1:
#   This is glitch in PCS data!
#   TODO: Add this to "post-processing" code?
before <- nrow(out)

out <- out[!(out$date == '2008-09-03' &
               out$race == 'Holland Ladies Tour (2.2)' &
               out$rider == 'Marianne Vos' &
               out$result != 6),]

after <- nrow(out)
stopifnot(before - after == 1)


# Step 2:
#   This is glitch in PCS data!
#   TODO: Add this to "post-processing" code?
#   Sorry, Kathrin... PCS messed up.
before <- nrow(out)

out <- out[!((out$date >= '2015-06-05' & out$date <= '2015-06-07') &
               out$rider == 'Kathrin Schweinberger'),]
out <- out[!((out$date >= '2015-07-09' & out$date <= '2015-07-10') &
               out$rider == 'Kathrin Schweinberger'),]
out <- out[!((out$date >= '2016-04-28' & out$date <= '2016-05-01') &
               out$rider == 'Kathrin Schweinberger'),]

after <- nrow(out)
stopifnot(before - after == 20)


# Finally: Check & Export data
duplicates <- findDuplicateResults(out)
stopifnot(nrow(duplicates) == 0)

rider_records_women <- out

usethis::use_data(rider_records_women,
                  overwrite = TRUE)

write_csv(rider_records_women, here::here("data/rider_records_women.csv"))
