# Global

library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(DT)
library(tidytext)
library(SnowballC)
library(wordcloud2)
library(shinycssloaders)
library(rtweet) 

# Modules ----
modules <- list.files("src/modules",
                      full.names = TRUE)
sapply(modules, source)

source("ui.R")
source("server.R")

shinyApp(ui, server)
