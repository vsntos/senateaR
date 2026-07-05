#' Fetch Historical Argentine Senators
#'
#' Retrieves the full historical list of Argentine senators, including their
#' legal and real tenure periods, province, party, and additional notes.
#'
#' @param url Character. JSON endpoint for historical senators (default from Senado Argentina).
#'
#' @return A tibble with one row per senator term and the following columns:
#' \describe{
#'   \item{id}{Senator identifier (string).}
#'   \item{name}{Full senator name ("LAST, FIRST").}
#'   \item{start_legal}{Legal start date of term (ISO format).}
#'   \item{end_legal}{Legal end date of term (ISO format).}
#'   \item{start_real}{Actual start date (ISO format).}
#'   \item{end_real}{Actual end date (ISO format).}
#'   \item{province}{Province or district represented.}
#'   \item{party_or_alliance}{Political party or alliance.}
#'   \item{replacement}{Replacer information (if any).}
#'   \item{notes}{Observations or special circumstances.}
#' }
#'
#' @examples
#' \dontrun{
#' senators_hist <- get_senators_historical()
#' glimpse(senators_hist)
#' }
#'
#' @export
get_senators_historical <- function(
    url = "https://www.senado.gob.ar/micrositios/DatosAbiertos/ExportarListadoSenadoresHistorico/json"
) {
  resp <- httr::GET(url)
  httr::stop_for_status(resp)
  dat <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  rows <- dat$table$rows

  df <- dplyr::as_tibble(rows) %>%
    dplyr::rename_with(~ tolower(gsub(" |/|\\.", "_", .x))) %>%
    dplyr::transmute(
      id = .data$id,
      name = .data$senador,
      start_legal = .data$inicio_periodo_legal,
      end_legal = .data$cese_periodo_legal,
      start_real = .data$inicio_periodo_real,
      end_real = .data$cese_periodo_real,
      province = .data$provincia,
      party_or_alliance = .data$partido_politico_o_alianza,
      replacement = .data$reemplazo,
      notes = .data$observaciones
    )

  df
}
