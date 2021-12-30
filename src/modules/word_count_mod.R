# Module to produce visualization of most frequent package function
# Using tidytext 

word_count_ui <- function(id) {
  ns <- NS(id)
  
  shinydashboard::box(
    title = "Most common package functions",
    width = NULL,
    collapsible = TRUE,
    status = "primary",
    wordcloud2Output(ns("word_plot")) %>% 
      withSpinner(type = 8,
                  color = "#4285F4")
  )
}

word_count_server <- function(id, data) {
  moduleServer(id,
               function(input, output, session) {
                 wordcloud2_rep <- repeatable(true_wordcloud2)
                 
                 cran_stem_stopwords <- c("data",
                                          "analysi",
                                          "doi",
                                          "packag",
                                          "function",
                                          "can",
                                          "us",
                                          "base",
                                          "r",
                                          "provid",
                                          "al",
                                          "et",
                                          "also",
                                          "http",
                                          "see",
                                          "two",
                                          "tool",
                                          "api",
                                          "via")
                 
                 
                 output$word_plot <- renderWordcloud2({
                   plotdata <- data %>%
                     select(short_desc) %>%
                     unnest_tokens(word, 
                                   short_desc, 
                                   token = "ngrams", 
                                   n = 1) %>%
                     count(word, sort = TRUE) %>%
                     filter(!word %in% stopwords::stopwords("en")) %>%
                     mutate(stem = SnowballC::wordStem(word)) %>%
                     filter(!stem %in% cran_stem_stopwords)
                   
                   wordcloud2_rep(data = plotdata %>%
                                    select(word, n))
                 })
               }
  )
}

true_wordcloud2 <- function (data, size = 1, minSize = 0, gridSize = 0, fontFamily = "Segoe UI", 
                         fontWeight = "bold", color = "random-dark", backgroundColor = "white", 
                         minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE, 
                         rotateRatio = 0.4, shape = "circle", ellipticity = 0.65, 
                         widgetsize = NULL, figPath = NULL, hoverFunction = NULL) 
{
  if ("table" %in% class(data)) {
    dataOut = data.frame(name = names(data), freq = as.vector(data))
  }
  else {
    data = as.data.frame(data)
    dataOut = data[, 1:2]
    names(dataOut) = c("name", "freq")
  }
  if (!is.null(figPath)) {
    if (!file.exists(figPath)) {
      stop("cannot find fig in the figPath")
    }
    spPath = strsplit(figPath, "\\.")[[1]]
    len = length(spPath)
    figClass = spPath[len]
    if (!figClass %in% c("jpeg", "jpg", "png", "bmp", "gif")) {
      stop("file should be a jpeg, jpg, png, bmp or gif file!")
    }
    base64 = base64enc::base64encode(figPath)
    base64 = paste0("data:image/", figClass, ";base64,", 
                    base64)
  }
  else {
    base64 = NULL
  }
  weightFactor = size * 180/max(dataOut$freq)
  settings <- list(word = dataOut$name, freq = dataOut$freq, 
                   fontFamily = fontFamily, fontWeight = fontWeight, color = color, 
                   minSize = minSize, weightFactor = weightFactor, backgroundColor = backgroundColor, 
                   gridSize = gridSize, minRotation = minRotation, maxRotation = maxRotation, 
                   shuffle = shuffle, rotateRatio = rotateRatio, shape = shape, 
                   ellipticity = ellipticity, figBase64 = base64, hover = htmlwidgets::JS(hoverFunction))
  chart = htmlwidgets::createWidget("wordcloud2", settings, 
                                    width = widgetsize[1], height = widgetsize[2], sizingPolicy = htmlwidgets::sizingPolicy(viewer.padding = 0, 
                                                                                                                            browser.padding = 0, browser.fill = TRUE))
  chart
}


