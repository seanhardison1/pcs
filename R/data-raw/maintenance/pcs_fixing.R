library(dplyr)
library(readr)
library(usethis)

source("R/data-raw/functions.R")

# Function fixes errors in PCS results for Elite Men
fix_pcs_results_men <- function(results)
{
  out <- results
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  out <- out[!(out$race == 'Tour Des Pays De Savoie (2.2U23)' &
                 out$rider == 'Dan Martin' &
                 is.na(out$pointspcs)),]
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  out <- out[!(out$date == '2009-04-15' &
                 out$race == 'La Côte Picarde (1.2U23)' &
                 out$rider == 'Jens Keukeleire' &
                 out$result == 73),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2009-05-20' &
                 out$race == "Giro d'Italia (2.HC)" &
                 out$stage == 'Stage 11 - Torino › Arenzano' &
                 out$rider == 'Dries Devenyns' &
                 out$result == 61),]
  out <- out[!(out$date == '2009-05-20' &
                 out$race == "Giro d'Italia (2.HC)" &
                 out$stage == 'Stage 11 - Torino › Arenzano' &
                 out$rider == 'Giovanni Visconti' &
                 out$result == 176),]
  out <- out[!(out$date == '2009-05-20' &
                 out$race == "Giro d'Italia (2.HC)" &
                 out$stage == 'Stage 11 - Torino › Arenzano' &
                 out$rider == 'Jos van Emden' &
                 out$result == 166),]
  out <- out[!(out$date == '2009-05-20' &
                 out$race == "Giro d'Italia (2.HC)" &
                 out$stage == 'Stage 11 - Torino › Arenzano' &
                 out$rider == 'Philippe Gilbert' &
                 out$result == 140),]
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
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
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  out <- out[!(out$date == '2010-08-10' &
                 out$race == 'Oslo Grand Prix (Nat.)' &
                 out$rider == 'Richie Porte' &
                 is.na(out$distance)),]
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  out <- out[!(out$date == '2012-06-15' &
                 out$race == 'Oberösterreichrundfahrt (2.2)' &
                 out$rider == 'Felix Großschartner' &
                 out$result != 995),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2020-08-25' &
                 out$race == 'Bretagne Classic - Ouest-France (1.UWT)' &
                 out$rider == 'Biniam Ghirmay Hailu' &
                 out$result == 96),]
  out <- out[!(out$date == '2020-08-25' &
                 out$race == 'Bretagne Classic - Ouest-France (1.UWT)' &
                 out$rider == 'Dries De Bondt' &
                 out$result == 46),]
  out <- out[!(out$date == '2020-08-25' &
                 out$race == 'Bretagne Classic - Ouest-France (1.UWT)' &
                 out$rider == 'Hideto Nakane' &
                 out$result == 55),]
  out <- out[!(out$date == '2020-08-25' &
                 out$race == 'Bretagne Classic - Ouest-France (1.UWT)' &
                 out$rider == 'Jannik Steimle' &
                 out$result == 48),]
  out <- out[!(out$date == '2020-08-25' &
                 out$race == 'Bretagne Classic - Ouest-France (1.UWT)' &
                 out$rider == 'Rémi Cavagna' &
                 out$result == 77),]
  # ----------------------------------------------------------------------------
  brx <- out %>%
    subset(out$date == '2020-08-30' &
             out$race == 'Brussels Cycling Classic (1.Pro)')
  old <- brx %>% subset(brx$distance == 203.7)
  new <- brx %>% subset(brx$distance == 204)
  out <- anti_join(out,
                   subset(old, old$rider %in% new$rider))
  # ----------------------------------------------------------------------------
  tdf <- subset(out,
                out$date == '2020-08-30' &
                  out$race == 'Tour de France (2.UWT)' &
                  out$stage == 'Stage 2 - Nice › Nice')
  old <- tdf %>% subset(tdf$distance == 186)
  new <- tdf %>% subset(tdf$distance == 185)
  out <- anti_join(out,
                   subset(old, old$rider %in% new$rider))
  # ----------------------------------------------------------------------------
  return(out)
}


# Function fixes errors in PCS results for Elite Women
fix_pcs_results_women <- function(results)
{
  out <- results
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  out <- out[!(out$date == '2008-09-03' &
                 out$race == 'Holland Ladies Tour (2.2)' &
                 out$rider == 'Marianne Vos' &
                 out$result != 6),]
  # ----------------------------------------------------------------------------
  #   This is glitch in PCS data!
  #   Sorry, Kathrin... PCS messed up.
  out <- out[!((out$date >= '2015-06-05' & out$date <= '2015-06-07') &
                 out$rider == 'Kathrin Schweinberger'),]
  out <- out[!((out$date >= '2015-07-09' & out$date <= '2015-07-10') &
                 out$rider == 'Kathrin Schweinberger'),]
  out <- out[!((out$date >= '2016-04-28' & out$date <= '2016-05-01') &
                 out$rider == 'Kathrin Schweinberger'),]
  # ----------------------------------------------------------------------------
  return(out)
}
