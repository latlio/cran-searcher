# Server
# Author: Lathan Liou

server <- function(input, output) {
  data <- readRDS("data/cran-2021-12-29.rds")
  year_count_server("year_plot", data)
  total_count_server("n_pkgs", data)
  import_count_server("imports_plot", data)
  suggest_count_server("suggests_plot", data)
  word_count_server("word_plot", data)
}