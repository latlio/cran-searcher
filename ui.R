# UI 
# Author: Lathan Liou
# Settings are represented by ALL CAPS objs and can be toggled in 00_settings.R

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = META$name),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Database", tabName = "database", icon = icon("table")),
      menuItem("Tweets", tabName = "tweet_wall", icon = icon("comment-dots")),
      menuItem("Source Code", icon = icon("code"),
               href = "https://github.com/latlio/cran-searcher"),
      menuItem("About", tabName = "about", icon = icon("user"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "dashboard",
              HTML(glue::glue(
                '<meta property="og:title" content="{META$name}">
            <meta property="og:description" content="{META$description}">
            <meta name="twitter:creator" content="@lathanliou">
            <meta name="twitter:site" content="https://lathanliou.com">
            '
              )),
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
              )
      ),
      tabItem(
        "tweet_wall",
        class = "text-center",
        tags$h1("Tweets about #rstats"),
        tags$h4("Borrowed from Garrick Aden-Buie"),
        # Tweet Wall - twitter.js and masonry.css - start --------------------
        # twitter.js has to be loaded after the page is loaded (divs exist and jquery is loaded)
        tags$head(HTML(
          '
        <script>
        document.addEventListener("DOMContentLoaded", function(event) {
          var script = document.createElement("script");
          script.type = "text/javascript";
          script.src  = "twitter.js";
          document.getElementsByTagName("head")[0].appendChild(script);
        });
        </script>
        ')),
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "masonry.css")),
        # Tweet Wall - twitter.js and masonry.css - end ----------------------
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
                  dateRangeInput("tweet_wall_daterange", "",
                                 start = today(), end = today(),
                                 min = "2015-01-01", max = today(),
                                 weekstart = 1, separator = " to "),
                  shinyThings::dropdownButtonUI("tweet_wall_date_presets",
                                                TWEET_WALL_DATE_INPUTS,
                                                class = "btn-default")
                )
              )
            )
            # Tweet Wall - Controls - end ---------------------------------------------
          ),
          shinyThings::paginationUI("tweet_wall_pager", width = 12, offset = 0)
        ),
        withSpinner(uiOutput("tweet_wall_tweets"), type = 8, color = "#4285F4"),
        shinyThings::pagerUI("tweet_wall_pager", centered = TRUE)
      ),
      tabItem(tabName = "about",
              fluidRow(
                # About Me --------------------------------------------------------
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
                  HTML(twemoji("1F44B")),
                  tags$strong("Hi! I'm Lathan."),
                  HTML(paste0("(", tags$a(href = "https://twitter.com/lathanliou", "@lathanliou"), ")"))
                ),
                tags$p(
                  "I'm currently a data scientist at Merck, where I focus on building Shiny apps, generating interactive reports, and doing differential expression analysis."),
                tags$p("I also perform epidemiological research at the Harvard School of Public Health and continue my research projects on ", 
                       tags$a(href = "https://github.com/dsrobertson/onlineFDR", "online false discovery rate", target = "_blank"), 
                       "from the University of Cambridge."),
                tags$p("You can read more about me and some of my other projects at ",
                       HTML(paste0(tags$a(href = "https://lathanliou.com", "lathanliou.com", target = "_blank"), "."))
                )
                )
              )
      )
    )
  )
)