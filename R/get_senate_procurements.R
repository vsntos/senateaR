#' Fetch Senate Procurement Notices ("Licitaciones")
#'
#' Retrieves the list of procurement notices ("Licitaciones") from the
#' Argentine Senate open-data endpoint. It parses the document details including
#' opening date, object description, and related document links.
#'
#' @param url Character. JSON endpoint URL (default to Senado Argentina source).
#' @return A tibble with one row per procurement notice and the following columns:
#' \describe{
#'   \item{opening_date}{Date and time the notice was opened.}
#'   \item{file_number}{Internal file number ("expediente").}
#'   \item{record}{Record/proceeding reference ("actuacion").}
#'   \item{subject}{Subject or object of the procurement ("objeto").}
#'   \item{opening_minutes_url}{URL to the opening minutes document, if available.}
#'   \item{opinion_url}{URL to the opinion/ruling document ("dictamen"), if available.}
#'   \item{disposition_url}{URL to the disposition document, if available.}
#'   \item{purchase_order_url}{URL to the purchase order document, if available.}
#' }
#' @export
#' @examples
#' \dontrun{
#' procurements <- get_senate_procurements()
#' head(procurements)
#' }
get_senate_procurements <- function(
    url = "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoLicitaciones/json"
) {
  txt <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")

  # Fix duplicated double quotes in the OBJETO field
  txt <- gsub('""', '"', txt, fixed = TRUE)

  # Extract the main fields via regex
  aperturas <- stringr::str_match_all(txt, '"APERTURA":\\s*"([^"]+)"')[[1]][,2]
  objetos <- stringr::str_match_all(txt, '"OBJETO":\\s*"([^"]+)"')[[1]][,2]
  actuaciones <- stringr::str_match_all(txt, '"ACTUACION":\\s*"([^"]+)"')[[1]][,2]
  expedientes <- stringr::str_match_all(txt, '"EXPEDIENTE":\\s*"([^"]+)"')[[1]][,2]
  links_apertura <- stringr::str_match_all(txt, '"ACTAS APERTURA":\\s*"([^"]*)"')[[1]][,2]
  links_dictamen <- stringr::str_match_all(txt, '"DICTAMEN":\\s*"([^"]*)"')[[1]][,2]
  links_disposicion <- stringr::str_match_all(txt, '"DISPOSICION":\\s*"([^"]*)"')[[1]][,2]
  ordens <- stringr::str_match_all(txt, '"ORDEN DE COMPRA":\\s*"([^"]*)"')[[1]][,2]

  tibble::tibble(
    opening_date = lubridate::ymd_hms(aperturas),
    file_number = expedientes,
    record = actuaciones,
    subject = objetos,
    opening_minutes_url = links_apertura,
    opinion_url = links_dictamen,
    disposition_url = links_disposicion,
    purchase_order_url = ordens
  )
}
