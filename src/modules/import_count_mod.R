# Module to produce visualization of most frequent imports

import_count_ui <- function(id) {
  ns <- NS(id)
  
  shinydashboard::box(
    title = "Most common imports",
    collapsible = TRUE,
    status = "primary",
    plotlyOutput(ns("imports_plot")) %>% 
      withSpinner(type = 8,
                  color = "#4285F4")
  )
}

import_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 output$imports_plot <- renderPlotly({
                   plotdata <- data %>%
                     separate_rows(imports, sep = ",") %>%
                     mutate(imports = str_trim(imports),
                            imports = str_replace(imports, "\\([^\\)]+\\)", ""),
                            imports = str_remove_all(imports, "\"")) %>%
                     drop_na() %>%
                     group_by(imports) %>%
                     count(sort = TRUE) %>%
                     ungroup() %>%
                     slice_head(n = 20)
                   p <- ggplot(plotdata, aes(x = reorder(imports, n), y = n)) + 
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
