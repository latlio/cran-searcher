# Module to produce visualization that counts packages by publication year

year_count_ui <- function(id) {
  ns <- NS(id)
  
  shinydashboard::box(
    title = "Packages published by year",
    collapsible = TRUE,
    status = "primary",
    plotlyOutput(ns("year_plot")) %>% 
      withSpinner(type = 8,
                  color = "#4285F4")
  )
}

year_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 output$year_plot <- renderPlotly({
                   plotdata <- data %>%
                     mutate(year = lubridate::year(date)) %>%
                     group_by(year) %>%
                     count()
                   p <- ggplot(plotdata, aes(x = year, y = n)) + 
                     geom_col(fill = ADMINLTE_COLORS$primary) + 
                     theme_bw() +
                     labs(x = "Year",
                          y = "Count")
                   ggplotly(p)
                 })
               }
  )
}