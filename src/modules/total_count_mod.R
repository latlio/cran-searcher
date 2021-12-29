# Module to produce value box with total number of packages

total_count_ui <- function(id) {
  ns <- NS(id)
  
  infoBoxOutput(ns("n_pkgs"))
}

total_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 output$n_pkgs <- renderInfoBox({
                   infoBox(
                     "Total Number of Packages",
                     nrow(data), 
                     icon = icon("chart-bar"),
                     color = "purple",
                     fill = TRUE
                   )
                 })
               }
  )
}