#
# Run `devtools::document()` whenever the documentation is changed!
#


#' Elite men profiles
#' 
#' A dataset containing rider profiles of elite men category.
#' 
#' @format Column description:
#' \describe{
#'   \item{\code{rider}}{Rider name}
#'   \item{\code{dob}}{Date of birth}
#'   \item{\code{nationality}}{Rider nationality}
#'   \item{\code{pob}}{Place of birth}
#'   \item{\code{current_team}}{Current team}
#'   \item{\code{weight}}{Rider weight in kilograms}
#'   \item{\code{height}}{Rider height in meters}
#'   \item{\code{one_day_races}}{Points per "one day races" specialty}
#'   \item{\code{gc}}{Points per "general classification" specialty}
#'   \item{\code{tt}}{Points per "time trial" specialty}
#'   \item{\code{sprint}}{Points per "sprint" specialty}
#'   \item{\code{climber}}{Points per "climber" specialty}
#' }
#' @source \url{http://www.procyclingstats.com}
"rider_profiles_men"


#' Elite men results
#' 
#' A dataset containing the results of elite men category.
#' 
#' @format Column description:
#' \describe{
#'   \item{\code{date}}{Result date.}
#'   \item{\code{result}}{Result (finishing place).\cr
#'     When a rider is listed as DNF, DNS, OTL etc., their results are encoded
#'     numerically as follows:
#'     \tabular{lcr}{
#'       \strong{Result} \tab \tab \strong{Code}\cr
#'       DNF \tab \tab 999\cr
#'       DNS \tab \tab 998\cr
#'       OTL \tab \tab 997\cr
#'       DF \tab \tab 996\cr
#'       NQ \tab \tab 995\cr
#'       DSQ \tab \tab 994\cr
#'     }}
#'   \item{\code{gc_result_on_stage}}{GC placement if applicable, otherwise NA.}
#'   \item{\code{race}}{Name of the race.}
#'   \item{\code{distance}}{Covered distance if applicable, otherwise NA.}
#'   \item{\code{pointspcs}}{Scored points (PCS ranking).}
#'   \item{\code{pointsuci}}{Scored points (UCI ranking).}
#'   \item{\code{stage}}{Stage description if applicable, 'One day' in case of classic
#'     races, eventually classification description (e.g. Point classification).}
#'   \item{\code{rider}}{Rider name.}
#'   \item{\code{team}}{Current team.}
#' }
#' @source \url{http://www.procyclingstats.com}
"rider_records_men"


#' Elite women profiles
#' 
#' A dataset containing rider profiles of elite women category.
#' 
#' @format Column description:
#' \describe{
#'   \item{\code{rider}}{Rider name}
#'   \item{\code{dob}}{Date of birth}
#'   \item{\code{nationality}}{Rider nationality}
#'   \item{\code{pob}}{Place of birth}
#'   \item{\code{current_team}}{Current team}
#'   \item{\code{weight}}{Rider weight in kilograms}
#'   \item{\code{height}}{Rider height in meters}
#'   \item{\code{one_day_races}}{Points per "one day races" specialty}
#'   \item{\code{gc}}{Points per "general classification" specialty}
#'   \item{\code{tt}}{Points per "time trial" specialty}
#'   \item{\code{sprint}}{Points per "sprint" specialty}
#'   \item{\code{climber}}{Points per "climber" specialty}
#' }
#' @source \url{http://www.procyclingstats.com}
"rider_profiles_women"


#' Elite women results
#' 
#' A dataset containing the results of elite women category.
#' 
#' @format Column description:
#' \describe{
#'   \item{\code{date}}{Result date.}
#'   \item{\code{result}}{Result (finishing place).\cr
#'     When a rider is listed as DNF, DNS, OTL etc., their results are encoded
#'     numerically as follows:
#'     \tabular{lcr}{
#'       \strong{Result} \tab \tab \strong{Code}\cr
#'       DNF \tab \tab 999\cr
#'       DNS \tab \tab 998\cr
#'       OTL \tab \tab 997\cr
#'       DF \tab \tab 996\cr
#'       NQ \tab \tab 995\cr
#'       DSQ \tab \tab 994\cr
#'     }}
#'   \item{\code{gc_result_on_stage}}{GC placement if applicable, otherwise NA.}
#'   \item{\code{race}}{Name of the race.}
#'   \item{\code{distance}}{Covered distance if applicable, otherwise NA.}
#'   \item{\code{pointspcs}}{Scored points (PCS ranking).}
#'   \item{\code{pointsuci}}{Scored points (UCI ranking).}
#'   \item{\code{stage}}{Stage description if applicable, 'One day' in case of classic
#'     races, eventually classification description (e.g. Point classification).}
#'   \item{\code{rider}}{Rider name.}
#'   \item{\code{team}}{Current team.}
#' }
#' @source \url{http://www.procyclingstats.com}
"rider_records_women"

