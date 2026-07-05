#' Fetch Senate Parliamentary Entries ("Asuntos Entrados")
#'
#' Retrieves the list of documents describing parliamentary entries ("Asuntos Entrados")
#' from the Argentine Senate. Returns session dates and corresponding PDF download URLs.
#'
#' @param url Character. The JSON endpoint URL (default is the official Senado Argentina source).
#' @return A tibble containing:
#' \describe{
#'   \item{meeting_date}{The date of the parliamentary session.}
#'   \item{url}{The direct URL to download the PDF document.}
#' }
#' @export
#' @examples
#' \dontrun{
#' entries <- get_senate_parliamentary_entries()
#' print(head(entries))
#' }
get_senate_parliamentary_entries <- function(
    url = "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoAsuntosEntrados/json"
) {
  txt <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")

  urls <- stringr::str_match_all(txt, '"URL":\\s*"([^"]+)"')[[1]][,2]
  dates <- stringr::str_match_all(txt, '"FECHA REUNION":\\s*"([^"]+)"')[[1]][,2]

  tibble::tibble(
    meeting_date = as.Date(dates),
    url = urls
  )
}
