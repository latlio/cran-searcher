# Module to produce visualization of most frequent suggests

suggest_count_ui <- function(id) {
  ns <- NS(id)
  
  shinydashboard::box(
    title = "Most common suggests",
    collapsible = TRUE,
    status = "primary",
    plotlyOutput(ns("suggests_plot")) %>% 
      withSpinner(type = 8,
                  color = "#4285F4")
  )
}

suggest_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 output$suggests_plot <- renderPlotly({
                   plotdata <- data %>%
                     separate_rows(suggests, sep = ",") %>%
                     mutate(suggests = str_trim(suggests),
                            suggests = str_replace(suggests, "\\([^\\)]+\\)", ""),
                            suggests = str_remove_all(suggests, "\"")) %>%
                     drop_na() %>%
                     group_by(suggests) %>%
                     count(sort = TRUE) %>%
                     ungroup() %>%
                     slice_head(n = 20)
                   p <- ggplot(plotdata, aes(x = reorder(suggests, n), y = n)) + 
                     geom_col() + 
                     theme_bw() +
                     labs(x = "Package",
                          y = "Count") + 
                     coord_flip()
                   ggplotly(p)
                 })
               }
  )
}