#' Retrieve Argentine Senate Voting Records for One or More Years
#'
#' This function scrapes the Argentine Senate's website to extract voting records
#' for one or multiple specified years. It returns a combined data frame of all records found.
#'
#' @param years A character vector or numeric vector of years (e.g., c("2023", "2024")).
#' @param step An integer indicating the number of results per page (default: 100).
#' @param max_pages Maximum number of pages per year to retrieve (default: 10).
#'
#' @return A tibble with voting records, including session date, act number, title, result,
#' and associated links (PDF, detail page, video).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' votes <- get_senate_votes(c("2023", "2024"))
#' }

get_senate_votes <- function(years = c("2024"), step = 100, max_pages = 10) {
  extract_page <- function(start = 0, period, length = step) {
    res <- httr::POST(
      url = "https://www.senado.gob.ar/votaciones/actas",
      body = list(
        `busqueda_actas[anio]` = period,
        `busqueda_actas[titulo]` = "",
        start = start,
        length = length
      ),
      encode = "form"
    )
    html <- httr::content(res, "text", encoding = "UTF-8") %>% rvest::read_html()
    tbl <- html %>% rvest::html_node("table#actasTable") %>% rvest::html_table(fill = TRUE)
    links <- html %>% rvest::html_nodes("table#actasTable tbody tr") %>%
      purrr::map_df(~{
        tds <- rvest::html_nodes(.x, "td")
        pdf <- rvest::html_node(tds[6], "a") %>% rvest::html_attr("href")
        det <- rvest::html_node(tds[7], "a") %>% rvest::html_attr("href")
        vid <- rvest::html_node(tds[8], "a") %>% rvest::html_attr("href")
        tibble::tibble(
          link_pdf = if (!is.na(pdf)) stringr::str_c("https://www.senado.gob.ar", pdf),
          link_detalle = if (!is.na(det)) stringr::str_c("https://www.senado.gob.ar", det),
          link_video = vid
        )
      })
    dplyr::bind_cols(tbl, links)
  }

  all_data <- purrr::map_df(years, function(y) {
    res_list <- list()
    for (i in seq(0, step * (max_pages - 1), by = step)) {
      pg <- extract_page(i, period = y)
      if (nrow(pg) == 0) break
      res_list[[length(res_list) + 1]] <- pg
    }
    df <- dplyr::bind_rows(res_list)
    df$year <- y
    df
  })

  all_data <- all_data %>%
    dplyr::mutate(
      session_date_raw = .data[["Fecha de Sesi\u00f3n"]],
      session_date = stringr::str_extract(.data$session_date_raw, "\\d{2}/\\d{2}/\\d{4}"),
      session_date = lubridate::dmy(.data$session_date),
      Resultado = stringr::str_trim(.data$Resultado)
    )

  return(all_data)
}
