#' Extract detailed nominal votes from Argentine Senate sessions
#'
#' @param ids A character or numeric vector with voting IDs (from the main actas table).
#' @return A data frame with one row per senator per vote, including vote type and ID.
#' @export
get_vote_detail <- function(ids) {
  ids <- as.character(ids)

  purrr::map_dfr(ids, function(id) {
    url <- paste0("https://www.senado.gob.ar/votaciones/detalleActa/", id)

    html <- tryCatch({
      httr::GET(url) %>%
        httr::content("text", encoding = "UTF-8") %>%
        rvest::read_html()
    }, error = function(e) return(NULL))

    if (is.null(html)) {
      message(glue::glue("Failed to access voting ID {id}"))
      return(tibble::tibble())
    }

    table_node <- html %>% rvest::html_node("table#tabla")
    if (is.na(table_node)) {
      message(glue::glue("No vote table found for voting ID {id}"))
      return(tibble::tibble())
    }

    table_result <- tryCatch({
      table_node %>%
        rvest::html_table(fill = TRUE) %>%
        dplyr::rename_with(~ stringr::str_to_lower(stringr::str_replace_all(.x, "\\s+", "_"))) %>%
        dplyr::mutate(id_votacion = id)
    }, error = function(e) {
      message(glue::glue("Error reading table for ID {id}"))
      return(tibble::tibble())
    })

    table_result
  })
}
