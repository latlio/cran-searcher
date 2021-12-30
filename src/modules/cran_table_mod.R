# Module for datatable

table_ui <- function(id) {
  ns <- NS(id)
  p("You can use regex in the main search bar")
  DT::dataTableOutput(ns("cran_table")) %>% 
    withSpinner(type = 8,
                color = "#4285F4")
}

table_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 final_data <- data %>%
                   select(package, short_desc, maintainer, date, long_desc, downloads_last_month)
                 
                 #can't vectorize since I run into an http request too long error, have to map individually
                 # downloads_yesterday <- map_dfr(final_data$package, 
                 #                                ~cranlogs::cran_downloads(.x) %>%
                 #                                  select(package, count) %>%
                 #                                  rename(downloads_yesterday = count))
                 # downloads_last_month <- map_dfr(final_data$package,
                 #                                 ~cranlogs::cran_downloads(.x,
                 #                                                           when = "last-month") %>%
                 #                                   group_by(package) %>%
                 #                                   summarize(downloads_last_month = sum(count)) %>%
                 #                                   ungroup())
                 # final_data2 <- final_data %>%
                 #   left_join(downloads_yesterday) %>%
                 #   left_join(downloads_last_month)
                 
                 output$cran_table <- DT::renderDataTable({
                   datatable(final_data,
                             rownames = FALSE,
                             filter = 'top',
                             extensions = 'Buttons',
                             options = list(search = list(regex = TRUE),
#https://stackoverflow.com/questions/52645959/r-datatables-do-not-display-buttons-and-length-menu-simultaneously
                                            dom = 'lBfrtip',
                                            buttons = c('csv')))
                 })
               }
  )
}