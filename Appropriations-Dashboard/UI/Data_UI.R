Data_UI <- page_fluid(
    full_screen = TRUE,
    # DTOutput("Filtered_Data_Table")
    
    navset_tab(
      #Size it properly?
      nav_panel(title = "Raw Data",
                DTOutput("Filtered_Data_Table")
                ),
      nav_panel(title = "Rolling Round Data",
                DTOutput("Totals_Data_Table")
                ),
      nav_panel(title = "Categorical Data",
                DTOutput("Cat_Data_Table")
                ),
      nav_panel(title = "Cumulative Data",
                DTOutput("Cum_Data_Table")
      )
    )
)