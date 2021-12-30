# Module for tweet bulletin board - NOT WORKING
# Borrowed from Garrick Aden-Buie

tweet_board_ui <- function(id) {
  ns <- NS(id)
  fluidRow(
    column(
      # Tweet Wall - Controls - start -------------------------------------------
      12,
      class = "col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3",
      tags$form(
        class = "form-inline",
        tags$div(
          class = "form-group",
          tags$div(
            class = "btn-toolbar btn-group-sm",
            dateRangeInput(ns("tweet_wall_daterange"), "",
                           start = "2015-01-01",
                           min = "2015-01-01"),
            weekstart = 1, 
            separator = " to ")
        )
      )
    )
  )
  uiOutput(ns("tweet_board_int")) %>%
    withSpinner(type = 8,
                color = "#4285F4")
  shinyThings::pagerUI(ns("tweet_wall_pager"), centered = TRUE)
}

tweet_board_server <- function(id) {
  moduleServer(id,
               function(input, output, session) {

                 tweets <- reactiveFileReader(1 * 60 * 1000, 
                                              session, 
                                              "data/rstats/tweets.rds", 
                                              import_tweets)
                 tweets_simple <- reactive({
                   req(tweets())
                   tweets() %>%
                     # filter(is_topic) %>%
                     tweets_just(user_id, 
                                 status_id, 
                                 created_at, 
                                 screen_name, 
                                 text)
                 })
                 
                 tweets_wall <- reactive({
                   tweets_simple()
                     # filter(
                     #   created_at >= input$tweet_wall_daterange[1],
                     #   created_at < input$tweet_wall_daterange[2] + 1
                     # )
                 })
                 
                 tweet_wall_n_items <- reactive({ nrow(tweets_wall()) })
                 
                 tweet_wall_page <- shinyThings::pager("tweet_wall_pager",
                                                       n_items = tweet_wall_n_items,
                                                       page_break = 20)
                 
                 output$tweet_board_int <- renderUI({
                   s_page_items <- tweet_wall_page() %||% 1L
                   
                   validate(need(
                     nrow(tweets_wall()) > 0,
                     "No tweets in selected date range. Try another set of dates."
                   ))
                   
                   tweets_wall() %>%
                     slice(s_page_items) %>%
                     masonify_tweets()
                 })
               })
}
