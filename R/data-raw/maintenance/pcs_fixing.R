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
  out <- out[!(out$date == '2011-07-08' &
                 out$race == 'Tour De Feminin - O Cenu Ceského Švýcarska (2.2)' &
                 out$stage == 'Stage 2 - Jiríkov › Jiríkov' &
                 out$rider == 'Jarmila Machačová' &
                 out$result != 69),]
  out <- out[!(out$date == '2011-07-09' &
                 out$race == 'Tour De Feminin - O Cenu Ceského Švýcarska (2.2)' &
                 out$stage == 'Stage 3 (ITT) - Bogatynia › Bogatynia' &
                 out$rider == 'Jarmila Machačová' &
                 out$result != 83),]
  out <- out[!(out$date == '2011-07-09' &
                 out$race == 'Tour De Feminin - O Cenu Ceského Švýcarska (2.2)' &
                 out$stage == 'Stage 4 - Rumburk › Rumburk' &
                 out$rider == 'Jarmila Machačová' &
                 out$result != 998),]
  out <- out[!(out$date == '2011-07-10' &
                 out$race == 'Tour De Feminin - O Cenu Ceského Švýcarska (2.2)' &
                 out$stage == 'Stage 6 - Varnsdorf › Krásná Lípa' &
                 out$rider == 'Jarmila Machačová'),]
  out <- out[!(out$race == 'Tour De Feminin - O Cenu Ceského Švýcarska (2.2)' &
                 out$stage == 'General classification' &
                 out$rider == 'Jarmila Machačová'),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == 'Anna van der Breggen' &
                 out$pointspcs != 80),]
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == 'Christine Majerus' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == "Jolien d'Hoore" &
                 out$pointspcs != 56),]
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == 'Katarzyna Niewiadoma' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == 'Lucy van der Haar' &
                 out$pointspcs != 32),]
  out <- out[!(out$date == '2014-04-27' &
                 out$race == 'Dwars door de Westhoek (1.1)' &
                 out$rider == 'Maria Giulia Confalonieri' &
                 out$pointspcs != 8),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2014-05-02' &
                 out$race == 'Prologue - Luxembourg › Luxembourg' &
                 out$rider == 'Amy Pieters' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-02' &
                 out$race == 'Prologue - Luxembourg › Luxembourg' &
                 out$rider == 'Anna van der Breggen' &
                 out$pointspcs != 4),]
  out <- out[!(out$date == '2014-05-02' &
                 out$race == 'Prologue - Luxembourg › Luxembourg' &
                 out$rider == 'Elizabeth Deignan' &
                 out$pointspcs != 5),]
  out <- out[!(out$date == '2014-05-02' &
                 out$race == 'Prologue - Luxembourg › Luxembourg' &
                 out$rider == 'Ellen van Dijk' &
                 out$pointspcs != 11),]
  out <- out[!(out$date == '2014-05-02' &
                 out$race == 'Prologue - Luxembourg › Luxembourg' &
                 out$rider == 'Marianne Vos' &
                 out$pointspcs != 16),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2014-05-03' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 1 - Garnich › Garnich' &
                 out$rider == 'Amy Pieters' &
                 out$pointspcs != 2),]
  out <- out[!(out$date == '2014-05-03' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 1 - Garnich › Garnich' &
                 out$rider == 'Anna van der Breggen' &
                 out$pointspcs != 16),]
  out <- out[!(out$date == '2014-05-03' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 1 - Garnich › Garnich' &
                 out$rider == 'Ashleigh Moolman' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-03' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 1 - Garnich › Garnich' &
                 out$rider == 'Marianne Vos' &
                 out$pointspcs != 5),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Aude Biannic' &
                 out$pointspcs != 2),]
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Barbara Guarischi' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Christine Majerus' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Elisa Longo Borghini' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Ellen van Dijk' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2014-05-04' &
                 out$race == 'Festival Luxembourgeois du cyclisme féminin Elsy Jacobs (2.1)' &
                 out$stage == 'Stage 2 - Mamer › Mamer' &
                 out$rider == 'Marianne Vos' &
                 out$pointspcs != 16),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2015-05-31' &
                 out$race == 'SwissEver GP Cham-Hagendorn (1.2)' &
                 out$rider == 'Kathrin Schweinberger' &
                 out$result != 64),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2015-06-26' &
                 out$race == 'National Championships Austria WE - ITT (NC)' &
                 out$rider == 'Kathrin Schweinberger' &
                 out$result != 7),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2015-06-28' &
                 out$race == 'National Championships Austria WE - Road Race (NC)' &
                 out$rider == 'Kathrin Schweinberger' &
                 out$result != 999),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2015-06-28' &
                 out$race == 'National Championships Slovenia WE - Road Race (NC)' &
                 out$rider == 'Urška Žigart' &
                 out$result != 9),]
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2016-05-22' &
                 out$race == 'SwissEver GP Cham - Hagendorn (1.2)' &
                 out$rider == 'Kathrin Schweinberger' &
                 out$result != 999),]
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
  # This one is tricky: Olena Pavlukhina got stripped from
  # her 40th place in WC 2016 results.
  wwc <- out %>% subset(out$date == '2016-10-15' &
                          out$race == 'World Championships WE - Road Race (WC)')
  old <- wwc %>%
    group_by(rider) %>%
    summarise(nres = n(), maxres = max(result)) %>%
    subset(nres > 1) %>%
    dplyr::select(-nres)
  new <- subset(wwc,
                wwc$rider %in% old$rider & wwc$result %in% old$maxres)
  out <- anti_join(out, new)
  # ----------------------------------------------------------------------------
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Cecilie Uttrup Ludwig' &
                 out$pointspcs != 90),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Demi Vollering' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Elisa Balsamo' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Erica Magnaldi' &
                 out$pointspcs != 2),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Évita Muzic' &
                 out$pointspcs != 9),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Katarzyna Niewiadoma' &
                 out$pointspcs != 4),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Katia Ragusa' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Pauliena Rooijakkers' &
                 out$pointspcs != 36),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Rachel Neylan' &
                 out$pointspcs != 7),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Rasa Leleivytė' &
                 out$pointspcs != 63),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Sabrina Stultiens' &
                 out$pointspcs != 22),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Silvia Zanardi' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Soraya Paladin' &
                 out$pointspcs != 18),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Špela Kern' &
                 out$pointspcs != 6),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Stine Borgli' &
                 !is.na(out$pointspcs)),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Tatiana Guderzo' &
                 out$pointspcs != 13),]
  out <- out[!(out$date == '2020-08-18' &
                 out$race == "Giro dell'Emilia Internazionale Donne Elite (1.Pro)" &
                 out$rider == 'Urša Pintar' &
                 out$pointspcs != 27),]
  # ----------------------------------------------------------------------------
  return(out)
}
