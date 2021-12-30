# Script that's scheduled to scrape CRAN

library(tidyverse)
library(rvest)
library(foreach)
library(doParallel)
library(cranlogs)
source("src/data_wrangling_functions/scrape_cran_fcts.R")
registerDoParallel(detectCores() - 1)

all_cran <- get_all_cran_packages()

all_cran_metadata <- foreach(i = 1:nrow(all_cran)) %dopar% {
  get_metadata_from_package(all_cran$package[i])
}

all_cran_metadata_df <- bind_rows(all_cran_metadata) %>%
  bind_cols(all_cran) %>%
  select(package, description, Imports, Suggests, Maintainer, Published, Description) %>%
  setNames(c("package", 
             "short_desc",
             "imports",
             "suggests",
             "maintainer",
             "date",
             "long_desc")) %>%
  mutate(date = as.Date(date)) %>%
  mutate(maintainer = str_trim(maintainer),
         maintainer = str_replace(maintainer, "<[^\\)]+>", ""),
         maintainer = noquote(maintainer))

#can't vectorize since I run into an http request too long error, have to map individually
downloads_last_month <- map_dfr(all_cran_metadata_df$package,
                                ~cranlogs::cran_downloads(.x,
                                                          when = "last-month") %>%
                                  group_by(package) %>%
                                  summarize(downloads_last_month = sum(count)) %>%
                                  ungroup())

all_cran_metadata_df2 <- all_cran_metadata_df %>%
  left_join(downloads_last_month)

write_rds(all_cran_metadata_df2, paste0("data/cran-data.rds"))
