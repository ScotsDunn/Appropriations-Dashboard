#--------------------------------#
# Filter by RR & CIO or Category #
#--------------------------------#
filtered_data <- reactive({
  selected_years <- input$yearInput
  selected_rounds <- input$roundInput
  selected_sems <- input$semesterInput
  df_filtered <- df %>%
    filter(grepl(paste(selected_years, collapse = "|"), Semester_Round_Year)) %>%
    filter(grepl(paste(selected_rounds, collapse = "|"), Semester_Round_Year)) %>%
    filter(grepl(paste(selected_sems, collapse = "|"), Semester_Round_Year))
  
  #Filter data based on selected category
  selected_categories <- input$Categories_Selected
  if(length(selected_categories) != 0){
    df_filtered <- df_filtered %>%
      filter(sapply(CIO_Category, function(x) any(x %in% selected_categories)))
  }
  
  #Filter data based on CIO ONLY if a CIO is selected
  selected_CIO <- input$CIO_Selected
  if(selected_CIO != "All CIOs"){
    df_filtered <- df_filtered %>%
      filter(CIO_Name == selected_CIO)
  }
  
  df_filtered$Semester_Round_Year <- fct_reorder(df_filtered$Semester_Round_Year, df_filtered$Date_RR_apps_closed)
  
  return(df_filtered)
})

#-------------------------------------------------------------#
# Long data for amount requested/allocated/approved bar graph # https://stackoverflow.com/questions/8134605/how-to-overlay-two-geom-bar
#-------------------------------------------------------------#
long_req_all_app_bargraph_data <- reactive({
  df <- filtered_data()
  
  agg_data <- df %>%
    group_by(Semester_Round_Year) %>%
    summarise(
      Total_Requested = sum(`Amount_Requested`, na.rm = TRUE),
      Total_Approved = sum(`Amount_Approved`, na.rm = TRUE),
      Total_Allocated = sum(`Amount_Allocated`, na.rm = TRUE)
    ) %>%
    pivot_longer(cols = c("Total_Approved", "Total_Allocated"), names_to = "Category", values_to = "Amount")
  
  agg_data$Type <- 'Total Requested'  # Create a new column for the legend of geom_bar
  agg_data$Type[agg_data$Category != ''] <- 'Total Requested'  # Adjust the column for geom_col
  
  agg_data$Category <- gsub("_", " ", agg_data$Category)
  agg_data$Type <- gsub("_", " ", agg_data$Type)
  agg_data$Category <- factor(agg_data$Category, levels = c("Total Approved", "Total Allocated"))
  
  return(agg_data)
})

#--------------------------------------------------------------#
# Long data for amount requested/allocated/approved Data Table # https://stackoverflow.com/questions/8134605/how-to-overlay-two-geom-bar
#--------------------------------------------------------------#
long_req_all_app_datatable_data <- reactive({
  df <- filtered_data() %>%
    arrange(Date_RR_apps_closed)
  
  agg_data <- df %>%
    group_by(Semester_Round_Year) %>%
    summarise(
      Total_Requested = sum(`Amount_Requested`, na.rm = TRUE),
      Total_Approved = sum(`Amount_Approved`, na.rm = TRUE),
      Total_Allocated = sum(`Amount_Allocated`, na.rm = TRUE),
      Date_RR_apps_closed = max(Date_RR_apps_closed)  # Or min(), depending on your need
    ) %>%
    ungroup() %>%
    arrange(Date_RR_apps_closed) %>%
    select(!Date_RR_apps_closed)
  
  return(agg_data)
})
#----------------------------------------------#
# Cumulative Requested/Allocated/Approved data #
#----------------------------------------------#
Cumulative_CIO_Sums <- reactive({
  data <- filtered_data()
  
  # data <- data %>%
  #   mutate(Cumulative_Requested = cumsum(Amount_Requested),
  #          Cumulative_Approved = cumsum(Amount_Approved),
  #          Cumulative_Allocated = cumsum(Amount_Allocated)) %>%
  #   select(Date_RR_apps_closed, Semester_Round_Year, Cumulative_Requested, Cumulative_Approved, Cumulative_Allocated) %>%
  #   relocate(Semester_Round_Year, .before = Date_RR_apps_closed) %>%
  #   relocate(Date_RR_apps_closed, .after = Cumulative_Allocated)
  # 
  # data$Semester_Round_Year <- factor(data$Semester_Round_Year, levels = unique(data$Semester_Round_Year))
  
  data <- data %>%
    group_by(Semester_Round_Year) %>%
    arrange(Date_RR_apps_closed) %>%
    summarize(
      Date_RR_apps_closed = first(Date_RR_apps_closed),
      Cumulative_Requested = sum(Amount_Requested),
      Cumulative_Approved = sum(Amount_Approved),
      Cumulative_Allocated = sum(Amount_Allocated)
    ) %>%
    mutate(
      Cumulative_Requested = cumsum(Cumulative_Requested),
      Cumulative_Approved = cumsum(Cumulative_Approved),
      Cumulative_Allocated = cumsum(Cumulative_Allocated)
    ) %>%
    ungroup() 
  
  return(data)
})

# -------------------------------------------------#
# Total Requested and Approved by funding category #
# -------------------------------------------------#
Agg_Funding_Cat_Data <- reactive({
  data <- filtered_data() %>%
    select(matches(".*_Requested$|.*_Approved$"), 
           -Amount_Requested, 
           -Amount_Approved)
  
  categories <- unique(sub("_(Requested|Approved)$", "", names(data)))
  
  df_summary <- data.frame(
    Category = character(),
    Total_Requested = numeric(),
    Total_Approved = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Step 3: Loop through each category and calculate the sums
  for (category in categories) {
    requested_col <- paste0(category, "_Requested")
    approved_col <- paste0(category, "_Approved")
    
    if (requested_col %in% names(data) & approved_col %in% names(data)) {
      total_requested <- sum(data[[requested_col]], na.rm = TRUE)
      total_approved <- sum(data[[approved_col]], na.rm = TRUE)
      
      df_summary <- rbind(df_summary, data.frame(
        Category = category,
        Total_Requested = total_requested,
        Total_Approved = total_approved
      ))
    }
  }
  
  df_summary$Category <- gsub("_", " ", df_summary$Category)
  
  df_summary <- df_summary %>%
    mutate(Category=factor(Category, levels=Category))  %>%
    arrange(desc(Total_Requested))
  
  return(df_summary)
})