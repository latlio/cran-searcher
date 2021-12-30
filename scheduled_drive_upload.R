# Script that's scheduled to update files in Google drive
# Files: 1) CRAN data 2) tweets

library(googledrive)
library(tidyverse)

drive_update(
  file = "Initiatives/CRAN++/cran_data.rds",
  media = "data/cran-data.rds"
)

drive_update(
  file = "Initiatives/CRAN++/rstats_tweets.rds",
  media = "data/rstats/tweets.rds"
)
