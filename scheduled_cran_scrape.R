# Script that's scheduled to scrape CRAN

library(tidyverse)
library(rvest)
library(foreach)
library(doParallel)
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

write_rds(all_cran_metadata_df, paste0("data/cran-", Sys.Date(), ".rds"))
