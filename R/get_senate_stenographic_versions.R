#' Fetch Senate Stenographic Versions
#'
#' Retrieves stenographic session transcripts from the Argentine Senate. Returns the session date,
#' type, session number, meeting number, and download URL of the transcript (version taquigrafica).
#'
#' @param url Character. JSON endpoint URL. Defaults to the official
#'   Senado Argentina stenographic-versions endpoint when `NULL`.
#' @return A tibble with columns: session_date, session_type, session_number,
#' meeting_number, and url.
#' @export
#' @examples
#' \dontrun{
#' transcripts <- get_senate_stenographic_versions()
#' head(transcripts)
#' }
get_senate_stenographic_versions <- function(url = NULL) {
  if (is.null(url)) {
    url <- "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoVersionesTac/json"
  }
  txt <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")

  dates <- stringr::str_match_all(txt, '"FECHA DE SESION":\\s*"([^"]+)"')[[1]][,2]
  types <- stringr::str_match_all(txt, '"TIPO DE SESION":\\s*"([^"]+)"')[[1]][,2]
  sessions <- stringr::str_match_all(txt, '"NRO DE SESION":\\s*"([^"]+)"')[[1]][,2]
  meetings <- stringr::str_match_all(txt, '"NRO DE REUNION":\\s*"([^"]+)"')[[1]][,2]
  urls <- stringr::str_match_all(txt, '"URL VESION TAQUIGRAFICA":\\s*"([^"]+)"')[[1]][,2]

  tibble::tibble(
    session_date = as.Date(dates, format = "%d-%m-%Y"),
    session_type = types,
    session_number = sessions,
    meeting_number = meetings,
    url = urls
  )
}
