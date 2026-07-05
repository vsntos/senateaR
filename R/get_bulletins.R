#' Fetch Senate Bulletins (Robust Fallback)
#'
#' Safely retrieves session bulletins from the Argentine Senate by parsing
#' malformed JSON with regex and string processing.
#'
#' @param url Character. Source URL (default: bulletins API).
#' @return A tibble with session date, bulletin number, and PDF URL.
#' @export
#' @examples
#' \dontrun{
#' bulletins <- get_bulletins()
#' head(bulletins)
#' }

get_bulletins <- function(
    url = "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoBoletinNovedades/json"
) {
  txt <- httr::content(httr::GET(url), as = "text", encoding = "UTF-8")

  urls <- stringr::str_match_all(txt, '"URL":\\s*"([^"]+)"')[[1]][,2]
  dates <- stringr::str_match_all(txt, '"FECHA SESION":\\s*"([^"]+)"')[[1]][,2]
  nums <- stringr::str_match_all(txt, '"NUMERO BOLETIN":\\s*"([^"]+)"')[[1]][,2]

  tibble::tibble(
    session_date = as.Date(dates),
    bulletin_number = nums,
    url = urls
  )
}
