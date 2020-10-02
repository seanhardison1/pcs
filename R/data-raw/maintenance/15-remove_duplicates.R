library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")

duplicates <- pcs::rider_records_men %>% findDuplicateResults()

# ******************************************************************************

out <- pcs::rider_records_men


# Step 1:
#   This is glitch in PCS data!
#   TODO: Add this to "post-processing" code?
before <- nrow(out)

out <- out[!(out$race == 'Tour Des Pays De Savoie (2.2U23)' &
               out$rider == 'Dan Martin' &
               is.na(out$pointspcs)),]

after <- nrow(out)
stopifnot(before - after == 2)

# Step 2:
#   This is glitch in PCS data!
#   TODO: Add this to "post-processing" code?
before <- nrow(out)

out <- out[!(out$date == '2009-07-07' &
             out$race == 'Tour de France (2.HC)' &
             out$stage == 'Stage 4 (TTT) - Montpellier › Montpellier' &
             ((out$rider == "Greg Van Avermaet" & out$result != 13) |
              (out$rider == "Niki Terpstra" & out$result != 15) |
              (out$rider == "Pierre Rolland" & out$result != 19) |
              (out$rider == "Rigoberto Urán" & out$result != 7) |
              (out$rider == "Rui Costa" & out$result != 7) |
              (out$rider == "Simon Geschke" & out$result != 20) |
              (out$rider == "Vincenzo Nibali" & out$result != 4))),]

after <- nrow(out)
stopifnot(before - after == 7)

# Step 3:
before <- nrow(out)

out <- out[!(out$date == '2010-08-10' &
               out$race == 'Oslo Grand Prix (Nat.)' &
               out$rider == 'Richie Porte' &
               is.na(out$distance)),]

after <- nrow(out)
stopifnot(before - after == 1)

# Step 4:
#   This is glitch in PCS data!
#   TODO: Add this to "post-processing" code?
before <- nrow(out)

out <- out[!(out$date == '2012-06-15' &
               out$race == 'Oberösterreichrundfahrt (2.2)' &
               out$rider == 'Felix Großschartner' &
               out$result != 995),]

after <- nrow(out)
stopifnot(before - after == 1)

# Step 5:
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

# Step 6:
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
duplicates <- findDuplicateResults(out)
stopifnot(nrow(duplicates) == 0)

rider_records_men <- out

usethis::use_data(rider_records_men,
                  overwrite = TRUE)

write_csv(rider_records_men, here::here("data/rider_records_men.csv"))
