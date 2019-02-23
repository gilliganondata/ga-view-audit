# We'll be calling the function below via lapply, and we'll get the results in a list, but go
# ahead and build up a couple of big data frames while we're at it for easy matching later on.

master_custom_dims <- data.frame(id = character(),
                                 accountId = character(),
                                 webPropertyId = character(),
                                 name = character(),
                                 index = numeric(),
                                 scope = character(),
                                 active = logical(),
                                 created = numeric(),
                                 updated = numeric())

master_custom_metrics <- data.frame(id = character(),
                                    accountId = character(),
                                    webPropertyId = character(),
                                    name = character(),
                                    index = numeric(),
                                    scope = character(),
                                    active = logical(),
                                    type = character(),
                                    created = numeric(),
                                    updated = numeric())

get_custom_variables <- function(account_id, property_id){
  
  # Get all custom dimensions for the property
  custom_dims <- ga_custom_vars_list(account_id, property_id,
                                     type = "customDimensions")
  
  # If no results returned, set custom_dims to NULL. Otherwise, extract
  # and filter the values into a data frame.
  if(nrow(custom_dims) == 0){
    custom_dims <- NULL
  } else {
    
    # Get just the active custom dims
    custom_dims <- custom_dims %>% 
      # select(-kind, -selfLink, -parentLink) %>%   # Legacy bit
      filter(active == TRUE) %>%
      mutate(created = as.Date(created),
             updated = as.Date(updated))
    
    # There's an outside chance that there ARE custom dimensions, but none are active
    if(nrow(custom_dims) == 0){
      custom_dims <- NULL
    } else {
      master_custom_dims <<- rbind(master_custom_dims, custom_dims)
    }
  }
  
  # Get all the custom metrics
  custom_metrics <-  ga_custom_vars_list(account_id, property_id,
                                         type = "customMetrics")
  
  
  # If no results returned, set custom_dims to NULL. Otherwise, extract
  # and filter the values into a data frame.
  if(nrow(custom_metrics) == 0){
    custom_metrics <- NULL
  } else {
    
    # Get just the active custom metrics
    custom_metrics <- custom_metrics %>% 
      # select(-kind, -selfLink, -parentLink) %>%  # Legacy bit
      filter(active == TRUE) %>% 
      mutate(created = as.Date(created),
             updated = as.Date(updated))
    
    # There's an outside chance that there ARE custom metrics, but none are active
    if(nrow(custom_metrics) == 0){
      custom_metrics <- NULL
    } else {
      master_custom_metrics <<- rbind(master_custom_metrics, custom_metrics)
    }
    
  }
  
  custom_vars <- list(custom_dims = custom_dims,
                      custom_metrics = custom_metrics)
  
}
