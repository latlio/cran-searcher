# Global

library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)

# Modules ----
modules <- list.files("src/modules",
                      full.names = TRUE)
sapply(modules, source)

source("ui.R")
source("server.R")

shinyApp(ui, server)
