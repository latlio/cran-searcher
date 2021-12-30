# UI 
# Author: Lathan Liou

source("src/modules/year_count_mod.R")

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "(C)RAN++"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Database", tabName = "database", icon = icon("table")),
      menuItem("Tweets", tabName = "tweets", icon = icon("twitter")),
      menuItem("Source Code", tabName = "code", icon = icon("github"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                year_count_ui("year_plot"),
                column(width = 6,
                       total_count_ui("n_pkgs"),
                       word_count_ui("word_plot")
                )
              ),
              fluidRow(
                import_count_ui("imports_plot"),
                suggest_count_ui("suggests_plot")
              )
      ),
      tabItem(tabName = "database"),
      tabItem(tabName = "tweets"),
      tabItem(tabName = "code")
    )
  )
)