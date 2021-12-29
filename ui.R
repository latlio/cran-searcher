# UI 
# Author: Lathan Liou

source("src/modules/year_count_mod.R")

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "(C)RAN++"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Database", tabName = "widgets", icon = icon("table")),
      menuItem("Tweets", tabName = "tweets", icon = icon("twitter")),
      menuItem("Source Code", tabName = "code", icon = icon("github"))
    )),
  dashboardBody(
    fluidRow(
      year_count_ui("year_plot"),
      total_count_ui("n_pkgs")
    )
  )
)