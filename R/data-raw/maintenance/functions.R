library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")

# Function fixes errors in PCS results for Elite Men
fix_pcs_results_men <- function(results)
{
  out <- results

  # Step 1:
  before <- nrow(out)
  
  out <- out[!(out$race == 'Tour Des Pays De Savoie (2.2U23)' &
                 out$rider == 'Dan Martin' &
                 is.na(out$pointspcs)),]
  
  after <- nrow(out)
  stopifnot(before - after == 2)

  # Step 2:
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
  
  out <- out[!(out$date == '2012-06-15' &
                 out$race == 'Oberösterreichrundfahrt (2.2)' &
                 out$rider == 'Felix Großschartner' &
                 out$result != 995),]
  
  after <- nrow(out)
  stopifnot(before - after == 1)
  
  return(out)
}


# Function fixes errors in PCS results for Elite Women
fix_pcs_results_women <- function(results)
{
  out <- results

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

  return(out)
}