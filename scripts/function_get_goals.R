get_goals <- function(account_id, property_id, view_id){
  
  # Get the goals. This returns a list with a buttload of unneeded meta data
  goals_list <- ga_goal_list(account_id, property_id, view_id)
  
  # If nothing came back, make a dummy data frame
  if(length(goals_list$items) == 0){
    goals_df <- data.frame(view_id = view_id,
                           goal_id = 0,
                           goal_name = "(No Active Goals Defined)",
                           goal_status = FALSE,
                           goal_created = NA,
                           goal_updated = NA)
  } else {
    
    # Extract the values we actually want and put them in a data frame
    goals_df <- data.frame(view_id = view_id,
                           goal_id = goals_list$items$id,
                           goal_name = goals_list$items$name,
                           goal_status = goals_list$items$active,
                           goal_created = goals_list$items$created,
                           goal_updated = goals_list$items$updated) %>% 
      filter(goal_status == TRUE)
  }
  
  # Sloppy code, but, if there WERE some goals, but they were ALL inactive,
  # then again need to make a dummy data frame.
  if(nrow(goals_df) == 0){
    goals_df <- data.frame(view_id = view_id,
                           goal_id = 0,
                           goal_name = "(No Active Goals Defined)",
                           goal_status = FALSE,
                           goal_created = NA,
                           goal_updated = NA)
  }
  
  goals_df$view_id <- as.character(goals_df$view_id)
  goals_df$goal_id <- as.character(goals_df$goal_id)
  goals_df$goal_name <- as.character(goals_df$goal_name)
  goals_df$goal_created <- as.Date(goals_df$goal_created)
  goals_df$goal_updated <- as.Date(goals_df$goal_updated)
  
  goals_df  
}