#---------------------------#
# Datatable of Filtered Daa #
#---------------------------#
output$Filtered_Data_Table = renderDT(
  filtered_data(),
  options = list(
    pageLength = 5
  )
)

output$Totals_Data_Table = renderDT(
  long_req_all_app_datatable_data(),
  options = list(
    pageLength = 10
  )
)

output$Cat_Data_Table = renderDT(
  Agg_Funding_Cat_Data(),
  options = list(
    pageLength = 10
  )
)

output$Cum_Data_Table = renderDT(
  Cumulative_CIO_Sums(),
  options = list(
    pageLength = 10
  )
)

#--------------------------------------#
# Selected Filters Reactive Statistics #
#--------------------------------------#
output$Total_Amount_Requested <- renderText({
  dollar(sum(filtered_data()$Amount_Requested)) #These values should be reactives, not in renderText
})

output$Total_Amount_Approved <- renderText({
  dollar(sum(filtered_data()$Amount_Approved)) #Doubt these computations add much but idk
})

output$Total_Amount_Allocated <- renderText({
  dollar(sum(filtered_data()$Amount_Allocated))
})

output$Num_Applications <- renderText({
  return(paste(nrow(filtered_data()), "Applications"))
})

output$Num_CIOs <- renderText({
  data <- filtered_data()
  num_unique_cio_name <- length(unique(data$CIO_Name))
  # total_rows <- nrow(data)
  # result <- paste(num_unique_cio_name, "CIOs,", total_rows, "apps")
  return(paste(num_unique_cio_name, "CIOs"))
})
#-----------------------------------------------------------#
# Total Amount Requested, Approved, and Allocated bar graph #
#-----------------------------------------------------------#
output$Total_Amounts_Bar_Graph <- renderPlotly({
  df <- long_req_all_app_bargraph_data()
  # ggplot(df) + 
  # geom_bar(aes(x= Semester_Round_Year, y = Total_Requested), stat = "identity", fill = "blue", width = 0.9, alpha = 0.3) +
  #   geom_col(aes(x=Semester_Round_Year,y=Amount, fill = Category), position ="dodge", width = 0.7) +
  #   theme_minimal() + 
  #   labs(x = "Rolling Round", y = "Amount ($)", title = NULL) +
  #   theme(axis.text.x = element_text(angle = 310, hjust = 0))
  
  p <- ggplot(df) + 
    geom_bar(aes(x = Semester_Round_Year, y = Total_Requested, fill = Type,
                 text = paste("<b>", "Total Requested","</b>",
                              "<br>", Semester_Round_Year,
                              "<br> Amount: ", scales::dollar(Total_Requested))), 
             stat = "identity", width = 0.9, alpha = 0.3) +
    geom_col(aes(x = Semester_Round_Year, y = Amount, fill = Category,
                 text = paste("<b>", Category,"</b>",
                              "<br>", Semester_Round_Year,
                              "<br> Amount: ", scales::dollar(Amount))), 
             position = "dodge", width = 0.7) +
    theme_minimal() + 
    labs(x = "Rolling Round", y = "Amount ($)", title = NULL) +
    theme(axis.text.x = element_text(angle = 310, hjust = 0)) +
    scale_y_continuous(labels = scales::label_dollar()) + 
    scale_fill_manual(values = c("Total Requested" = "blue", 
                                 "Total Approved" = "chartreuse2",
                                 "Total Allocated" = "goldenrod1"))
  ggplotly(p, tooltip = "text")
  })

#----------------------------------------------#
# Amount Approved by Filter Scatterplot #
#----------------------------------------------#
output$Scatter_by_Filter <- renderPlotly({
  df <- filtered_data()
  
  #desired_maximum_marker_size <- 50
  #sizeRefCalc <- 2 * max(df$Allocation_Rate, na.rm = TRUE) / (desired_maximum_marker_size ** 2) 
  #^Recommended formula for calculating sizeRef according to plotly documentation
  
  #https://stackoverflow.com/questions/37261327/overlapping-points-and-text-with-plotly-in-rshiny?rq=4
  
  fig <- df %>%
    plot_ly(
      type = "box", boxpoints = "all", jitter = .6, pointpos = 0,
      mode = 'markers',
      x = ~ Semester_Round_Year,
      y = ~ Amount_Approved,
      marker = list(
        size = 8,
        color = 'rgba(0, 0, 255, 1)',  # Set marker color to a visible color (e.g., blue)
        line = list(
          width = 1,
          color = 'rgba(0, 0, 0, 1)'  # Set marker border color to a visible color (e.g., black)
        )
      ),
      fillcolor = 'rgba(255,255,255,0)',  # Transparent fill for the box
      line = list(
        color = 'rgba(255,255,255,0)'  # Transparent border for the box
      ),
      color = ~ CIO_Category,
      text = ~ CIO_Name,
      hoverinfo = 'text',
      hovertext = ~ paste(
        "<b>", CIO_Name, "</b><br><br>",
        "Amount Requested: $", formatC(Amount_Requested, format = "f", big.mark = ",", digits = 2), "<br>",
        "Amount Approved: $", formatC(Amount_Approved, format = "f", big.mark = ",", digits = 2), "<br>",
        "Amount Allocated: $", formatC(Amount_Allocated, format = "f", big.mark = ",", digits = 2), "<br>",
        "Allocation Rate: ", formatC(Allocation_Rate, format = "f", digits = 2), "%",
        sep = ""
      )
    )
  
  fig <- fig %>%
    layout(
      title = "",
      xaxis = list(title = "Rolling Round"),
      yaxis = list(title = "Amount Approved", tickformat = "$,.0f"),
      legend = list(orientation = 'h', y = -1),
      annotations = list(
        x = 1,
        y = -0.75,
        text = "", #"Bubble size represents allocation rate.",
        showarrow = FALSE,
        xref = 'paper',
        yref = 'paper',
        xanchor = 'right',
        yanchor = 'auto',
        xshift = 0,
        yshift = 0,
        font = list(size = 12)
      )
    )
  
  fig
})

output$Cumulative_CIO_Graph <- renderPlotly({
  df <- Cumulative_CIO_Sums()
  p <- ggplot(df, aes(x = Semester_Round_Year, group = 1)) +
    # #Area graph for amount requested
    geom_area(color = "black", fill = "skyblue",position = "identity", aes(y = Cumulative_Requested)) +
    geom_point(shape = 16, size = 2.5, colour = "blue", aes(y = Cumulative_Requested,
                                                            text = paste("<b> Cumulative Requested: </b><br>",
                                                                         scales::dollar(Cumulative_Requested)))) +
    #Area graph for amount Approved
    geom_area(color = "black", fill = "lightgreen", aes(y = Cumulative_Approved)) +
    geom_point(shape = 16, size = 2.5, colour = "green3", aes(y = Cumulative_Approved,
                                                             text = paste("<b> Cumulative Approved: </b><br>",
                                                                          scales::dollar(Cumulative_Approved)))) +
    #Area graph for amount allocated
    geom_area(color = "black", fill = "peachpuff", aes(y = Cumulative_Allocated)) +
    geom_point(shape = 16, size = 2.5, colour = "lightsalmon", aes(y = Cumulative_Allocated,
                                                                   text = paste("<b> Cumulative Allocated: </b><br>",
                                                                                scales::dollar(Cumulative_Allocated)))) +
    labs(title = "Cumulative Requests Over Time",
         x = "Date",
         y = "Cumulative Requests") +
    theme_minimal() + 
    theme(axis.text.x = element_text(angle = 50, hjust = 0)) + 
    scale_y_continuous(labels = scales::label_dollar())
  
  ggplotly(p, tooltip = "text")
})

#-----------------------------------------------------------------#
# Amount Requested vs Approved by funding category lollipop graph #
#-----------------------------------------------------------------#
output$Funding_Cat_Lollipop <- renderPlotly({
  df <- Agg_Funding_Cat_Data()
  p <- ggplot(df) +
    geom_segment(aes(x=Category, xend=Category, y=Total_Requested, yend=Total_Approved), color="grey") +
    geom_point(aes(x=Category, y=Total_Approved,
                   text = paste("<b>Approved:</b><br>",
                                scales::dollar(Total_Approved))), 
               color=rgb(0.2,0.7,0.1,.8), size=3 ) + 
    geom_point(aes(x=Category, y=Total_Requested,
                   text = paste("<b>Requested:</b><br>",
                                scales::dollar(Total_Requested))), 
               color=rgb(0.1,0.2,0.7,.5), size=2.7 ) +
    coord_flip()+
    #theme_ipsum() +
    xlab("") +
    ylab("Amount ($)") + 
    scale_y_continuous(labels = scales::label_dollar())
  
  ggplotly(p, tooltip = "text")
})