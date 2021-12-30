# UI 
# Author: Lathan Liou

theme_css   = c("ocean-next/AdminLTE.css", "ocean-next/_all-skins.css")

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "(C)RAN++"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Database", tabName = "database", icon = icon("table")),
      menuItem("Tweets", tabName = "tweets", icon = icon("comment-dots")),
      menuItem("Source Code", icon = icon("code"),
               href = "https://github.com/latlio/cran-searcher"),
      menuItem("About", tabName = "about", icon = icon("user"))
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
      tabItem(tabName = "database",
              fluidRow(
                table_ui("cran_table")
              )),
      tabItem(tabName = "tweets"),
      tabItem(tabName = "about",
              fluidRow(
                # About - About Me - start ------------------------------------------------
                box(
                  title = "About me",
                  status = "danger",
                  width = "6 col-lg-4",
                  tags$p(
                    class = "text-center",
                    tags$img(class = "img-responsive img-rounded center-block", src = "lathan.png", style = "max-width: 150px;")
                  ),
                  tags$p(
                    class = "text-center",
                    tags$strong("Hi! I'm lathan."),
                    HTML(paste0("(", tags$a(href = "https://twitter.com/lathanliou", "@lathanliou"), ")"))
                  ),
                  tags$p(
                    "I'm currently a data scientist at Merck, where I focus on building Shiny apps, generating interactive reports, and doing differential expresssion analysis."),
                  tags$p("I also perform epidemiological research at the Harvard School of Public Health and continue researching", 
                         tags$a(href = "https://github.com/dsrobertson/onlineFDR", "online false discovery rate", target = "_blank"), 
                         "at the University of Cambridge."),
                  tags$p("You can read more about me and some of my other projects at ",
                         HTML(paste0(tags$a(href = "https://lathanliou.com", "lathanliou.com", target = "_blank"), "."))
                  )
                )
              )
      )
    )
  )
)