#' Fetch Argentine Senate Commissions
#'
#' This function retrieves all current Senate commissions from the
#' Argentine Senate open-data API, including both unicameral and bicameral types.
#'
#' @param url Character. API endpoint URL. Defaults to the official
#'   Senado Argentina commissions endpoint when `NULL`.
#'
#' @return A tibble with one row per commission and the following columns:
#' \describe{
#'   \item{name}{Commission name.}
#'   \item{type}{Commission type (e.g., BICAMERAL PERMANENTE, UNICAMERAL PERMANENTE).}
#' }
#'
#' @examples
#' \dontrun{
#' commissions <- get_commissions()
#' print(commissions)
#' }
#'
#' @export
get_commissions <- function(url = NULL) {
  if (is.null(url)) {
    url <- "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoComisiones/json/todas"
  }
  resp <- httr::GET(url)
  httr::stop_for_status(resp)
  dat <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  rows <- dat$table$rows

  df <- dplyr::as_tibble(rows) %>%
    dplyr::rename(
      name = "NOMBRE",
      type = "TIPO_COMISION"
    )

  df
}
