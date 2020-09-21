#
# Run `devtools::document()` whenever the documentation is changed!
#


#' Elite men profiles
#' 
#' A dataset containing rider profiles of elite men category.
#' 
#' @format Column description:
#' \describe{
#'   \item{rider}{Rider name}
#'   \item{dob}{Date of birth}
#'   \item{nationality}{Rider nationality}
#'   \item{pob}{Place of birth}
#'   \item{current_team}{Current team}
#'   \item{weight}{Rider weight in kilograms}
#'   \item{height}{Rider height in meters}
#'   \item{one_day_races}{Points per "one day races" specialty}
#'   \item{gc}{Points per "general classification" specialty}
#'   \item{tt}{Points per "time trial" specialty}
#'   \item{sprint}{Points per "sprint" specialty}
#'   \item{climber}{Points per "climber" specialty}
#' }
"rider_profiles_men"


#' Elite men results
#' 
#' A dataset containing the results of elite men category.
#' 
#' @format Column description:
#' \describe{
#'   \item{date}{Result date}
#'   \item{result}{Result (finishing place)}
#'   \item{gc_result_on_stage}{GC placement if applicable, otherwise NA}
#'   \item{race}{Name of the race}
#'   \item{distance}{Covered distance if applicable, otherwise NA}
#'   \item{pointspcs}{Scored points (PCS ranking)}
#'   \item{pointsuci}{Scored points (UCI ranking)}
#'   \item{stage}{Stage description if applicable, 'One day' in case of classic
#'     races, eventually classification description (e.g. Point classification)}
#'   \item{rider}{Rider name}
#'   \item{team}{Current team}
#' }
"rider_records_men"


#' Elite women profiles
#' 
#' A dataset containing rider profiles of elite women category.
#' 
#' @format Column description:
#' \describe{
#'   \item{rider}{Rider name}
#'   \item{dob}{Date of birth}
#'   \item{nationality}{Rider nationality}
#'   \item{pob}{Place of birth}
#'   \item{current_team}{Current team}
#'   \item{weight}{Rider weight in kilograms}
#'   \item{height}{Rider height in meters}
#'   \item{one_day_races}{Points per "one day races" specialty}
#'   \item{gc}{Points per "general classification" specialty}
#'   \item{tt}{Points per "time trial" specialty}
#'   \item{sprint}{Points per "sprint" specialty}
#'   \item{climber}{Points per "climber" specialty}
#' }
"rider_profiles_women"


#' Elite women results
#' 
#' A dataset containing the results of elite women category.
#' 
#' @format Column description:
#' \describe{
#'   \item{date}{Result date}
#'   \item{result}{Result (finishing place)}
#'   \item{gc_result_on_stage}{GC placement if applicable, otherwise NA}
#'   \item{race}{Name of the race}
#'   \item{distance}{Covered distance if applicable, otherwise NA}
#'   \item{pointspcs}{Scored points (PCS ranking)}
#'   \item{pointsuci}{Scored points (UCI ranking)}
#'   \item{stage}{Stage description if applicable, 'One day' in case of classic
#'     races, eventually classification description (e.g. Point classification)}
#'   \item{rider}{Rider name}
#'   \item{team}{Current team}
#' }
"rider_records_women"