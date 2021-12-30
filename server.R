# Server
# Author: Lathan Liou

server <- function(input, output, session) {
  data <- readRDS("data/cran-2021-12-29.rds")
  year_count_server("year_plot", data)
  total_count_server("n_pkgs", data)
  import_count_server("imports_plot", data)
  suggest_count_server("suggests_plot", data)
  word_count_server("word_plot", data)
  table_server("cran_table", data)
  # tweet_board_server("tweet_board")
  # Tweet Wall --------------------------------------------------------------
  tweets <- reactiveFileReader(1 * 60 * 1000, 
                               session, 
                               "data/rstats/tweets.rds", 
                               import_tweets)
  
  tweets_simple <- reactive({
    req(tweets())
    tweets() %>%
      # filter(is_topic) %>%
      tweets_just(user_id, status_id, created_at, screen_name, text)
  })
  
  tweets_wall <- reactive({
    tweets_simple() %>%
      filter(
        created_at >= input$tweet_wall_daterange[1],
        created_at < input$tweet_wall_daterange[2] + 1
      )
  })
  
  tweet_wall_page_break = 20
  tweet_wall_n_items <- reactive({ nrow(tweets_wall()) })
  tweet_wall_page <- shinyThings::pager("tweet_wall_pager",
                                        n_items = tweet_wall_n_items,
                                        page_break = tweet_wall_page_break)
  
  output$tweet_wall_tweets <- renderUI({
    s_page_items <- tweet_wall_page() %||% 1L
    
    validate(need(
      nrow(tweets_wall()) > 0,
      "No tweets in selected date range. Try another set of dates."
    ))
    
    tweets_wall() %>%
      slice(s_page_items) %>%
      masonify_tweets()
  })
  
  tweet_wall_date_preset <- shinyThings::dropdownButton("tweet_wall_date_presets",
                                                        options = TWEET_WALL_DATE_INPUTS)
  
  observe({
    req(tweet_wall_date_preset())
    update_dates <- TWEET_WALL_DATE_RANGE(tweet_wall_date_preset())
    if (any(is.na(update_dates))) return(NULL)
    update_dates <- strftime(update_dates, "%F", usetz = TRUE) %>% unname()
    updateDateRangeInput(session, "tweet_wall_daterange", start = update_dates[1], end = update_dates[2], max = today())
  })
}