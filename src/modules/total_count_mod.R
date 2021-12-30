# Module to produce value box with total number of packages

total_count_ui <- function(id) {
  ns <- NS(id)
  
  # infoBoxOutput(ns("n_pkgs"))
  
  shinydashboard::box(
    title = paste0("Total # of CRAN Packages as of ", Sys.Date()),
    width = NULL,
    background = "purple",
    textOutput(ns("n_pkgs"))
  )
}

total_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 
                 output$n_pkgs <- renderText({
                   nrow(data)
                 })
               }
  )
}