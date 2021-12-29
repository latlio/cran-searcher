# Server
# Author: Lathan Liou

server <- function(input, output) {
  data <- readRDS("data/cran-2021-12-29.rds")
  year_count_server("year_plot", data)
  total_count_server("n_pkgs", data)
}