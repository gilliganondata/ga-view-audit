# Get top 5 custom dimension values by hits
get_custom_dim_hits <- function(view_id, dimension_id){
  
  # Add a 1 second delay to keep from maxing out the quota of 100 requests per 100 seconds per user
  Sys.sleep(1)
  
  dim_order <- order_type("hits", sort_order = "DESCENDING",
                          orderType = "VALUE")
  
  # Pull the data
  custom_dim_data <- google_analytics_4(view_id,
                                        date_range = date_range,
                                        metrics = "hits",
                                        dimensions = dimension_id,
                                        order = dim_order)
  
  if(is.null(custom_dim_data)){
    dim_summary = "(No data)"
  } else {
    
    names(custom_dim_data) <- c("name", "hits")
    
    # Ultimately, we just want a single text value, so we'll take the top
    # X values and build a single string with X rows
    dim_summary <- custom_dim_data %>% 
      top_n(custom_dim_top_x) %>% 
      mutate(combined = paste0(name, " (", 
                               format(hits, big.mark = ",", trim = TRUE), " hits)"))
    dim_summary <- paste(dim_summary$combined, collapse = "\n")
  }
  
  result <- list(view_id = view_id,
                 dimension_id = dimension_id,
                 top_values = dim_summary)
  
}


# Get the total hits for a given custom metric
get_custom_metric_hits <- function(view_id, metric_id){
  
  # Add a 1 second delay to keep from maxing out the quota of 100 requests per 100 seconds per user
  Sys.sleep(1)
  
  # Pull the data
  custom_metric_data <- google_analytics_4(view_id,
                                           date_range = date_range,
                                           metrics = metric_id)
  
  # If there is no data for the metric, set it to zero
  if(is.null(custom_metric_data)){
    custom_metric_data[[1]] = 0
  }
  
  # Set up the values to return
  result <- list(view_id = view_id,
                 metric_id = metric_id,
                 total_hits = custom_metric_data[[1]])
  
}


# Get the total conversions for a given goal
get_goal_conversions <- function(view_id, goal_id){
  
  # Add a 1 second delay to keep from maxing out the quota of 100 requests per 100 seconds per user
  Sys.sleep(1)
  
  # Logic elsewhere will call this function even if a view has no active goals. In that case
  # the goal_id is passed in as "0"
  if(goal_id == "0"){
    goal_data <- data.frame(data_snapshot = NA)
  } else {
    goal_data <- google_analytics_4(view_id,
                                    date_range = date_range,
                                    metrics = paste0("goal",goal_id,"Completions"))
    
    if(is.null(goal_data)){
      goal_data <- data.frame(data_snapshot = NA)
    } else {
      names(goal_data) <- "data_snapshot"
    }
  }
  goal_data
}