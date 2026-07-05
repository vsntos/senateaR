#' Fetch Current Argentine Senators
#'
#' This function retrieves the list of current senators from the
#' Argentine Senate open-data endpoint, parses the JSON response, and
#' returns a tibble with selected senator attributes.
#'
#' @param url Character. API endpoint URL (default from Senado Argentina).
#'
#' @return A tibble with one row per senator and the following columns:
#' \describe{
#'   \item{id}{Senator identifier (string).}
#'   \item{bloc}{Bloc or parliamentary grouping.}
#'   \item{last_name}{Senator's last name.}
#'   \item{first_name}{Senator's first name.}
#'   \item{province}{Province or district represented.}
#'   \item{party_or_alliance}{Party or alliance name.}
#'   \item{start_date}{Legal start date of mandate (ISO format).}
#'   \item{end_date}{Legal end date of mandate (ISO format or missing).}
#'   \item{real_start}{Actual start date (ISO format).}
#'   \item{real_end}{Actual end date (if available).}
#'   \item{email}{Official email address.}
#'   \item{phone}{Contact phone number(s).}
#'   \item{photo_url}{URL link to senator's photo.}
#'   \item{facebook}{Facebook profile URL (if available).}
#'   \item{twitter}{Twitter/X profile URL (if available).}
#'   \item{instagram}{Instagram profile URL (if available).}
#'   \item{youtube}{YouTube channel URL (if available).}
#' }
#'
#' @examples
#' \dontrun{
#'   senators <- get_senators()
#'   glimpse(senators)
#' }
#'
#' @export
get_senators <- function(
    url = "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoSenadores/json"
) {
  resp <- httr::GET(url)
  httr::stop_for_status(resp)
  dat <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  rows <- dat$table$rows
  df <- dplyr::as_tibble(rows) %>%
    dplyr::rename_with(~ tolower(gsub(" |/|\\.", "_", .x))) %>%
    dplyr::transmute(
      id = .data$id,
      bloc = .data$bloque,
      last_name = .data$apellido,
      first_name = .data$nombre,
      province = .data$provincia,
      party_or_alliance = .data$partido_o_alianza,
      start_date = .data$d_legal,
      end_date = .data$c_legal,
      real_start = .data$d_real,
      real_end = .data$c_real,
      email = .data$email,
      phone = .data$telefono,
      photo_url = .data$foto,
      facebook = .data$facebook,
      twitter = .data$twitter,
      instagram = .data$instagram,
      youtube = .data$youtube
    )
  return(df)
}
