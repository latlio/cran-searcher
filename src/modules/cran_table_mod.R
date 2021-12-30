# Module for datatable

table_ui <- function(id) {
  ns <- NS(id)
  DT::dataTableOutput(ns("cran_table"))
}

table_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 output$cran_table <- DT::renderDataTable({
                   datatable(data %>%
                               select(package, short_desc, maintainer, date, long_desc),
                             rownames = FALSE,
                             filter = 'top',
                             options = list(search = list(regex = TRUE)))
                 })
               }
  )
}