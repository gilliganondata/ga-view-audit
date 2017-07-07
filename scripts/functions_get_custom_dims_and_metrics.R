get_custom_dims_list <- function(viewId){
  
  # Figure out what property the view is in -- a simple lookup in `final_view_list`. Base R 
  # might have been cleaner notation and avoided the as.character() at the end, but... this works.
  property_id <- final_view_list %>% 
    filter(view_id == viewId) %>% 
    select(webPropertyId) %>% 
    as.character()
  
  # Get the custom dims for that property
  custom_dims <- custom_vars_all[[property_id]]$custom_dims
}

get_custom_metrics_list <- function(viewId){
  
  # Figure out what property the view is in -- a simple lookup in `final_view_list`. Base R 
  # might have been cleaner notation and avoided the as.character() at the end, but... this works.
  property_id <- final_view_list %>% 
    filter(viewId == view_id) %>% 
    select(webPropertyId) %>% 
    as.character()
  
  # Get the custom dims for that property
  custom_metrics <- custom_vars_all[[property_id]]$custom_metrics
}