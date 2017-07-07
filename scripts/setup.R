
options(googleAuthR.client_id = ga_client_id)
options(googleAuthR.client_secret = ga_client_secret) 
options(googleAuthR.verbose = 2)

# This jacks up the memory available for the JVM that does the heavy lifting in XLConnect.
# It can be a little dicey. For details, see the documentation at 
# https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf
options(java.parameters = "-Xmx2048m" ) 

library(tidyverse)
library(stringr)
library(googleAnalyticsR)
library(knitr)
library(XLConnect)

# Authorize Google Analytics
ga_auth()

# Load list of key views. This should be a comma-delimited file with the 
# first column with a heading of "view_id" and the second column with a heading of
# "label". The "label" won't be used anywhere -- it's purely for your reference in
# the file.
key_views_list <- read.csv("input/key_views.csv", stringsAsFactors = FALSE)
key_views_list$view_id <- as.character(key_views_list$view_id)

# Load list of all views available
all_views <- ga_account_list()

# Get the additional meta data for each view
final_view_list <- key_views_list %>% 
  left_join(all_views, by = c(view_id = "viewId")) 

# There may be multiple views using the same property, so make a de-duplicated
# list of properties
final_property_list <- final_view_list %>% 
  group_by(webPropertyId, accountId) %>% summarise()