Total_Value_Boxes <- layout_columns(
  fill = FALSE,
  min_height = 100,
  value_box(
    title = "Total Requested",
    value = textOutput("Total_Amount_Requested"),
    showcase = bsicons::bs_icon("coin"), showcase_layout = "left center",
    theme_color = "blue"
  ),
  value_box(
    title = "Total Approved",
    value = textOutput("Total_Amount_Approved"),
    showcase = bsicons::bs_icon("check-square"), showcase_layout = "left center", 
    theme_color = "success"
  ),
  value_box(
    title = "Total Allocated",
    value = textOutput("Total_Amount_Allocated"),
    showcase = bsicons::bs_icon("cash-coin"), showcase_layout = "left center",
    theme_color = "warning"
  )
)

Request_Count_and_Graph_Row <- layout_columns(
  value_box(
    fill = FALSE,
    title = textOutput("Num_Applications"),
    value = textOutput("Num_CIOs"),
    # theme_color = "success"?
  ),
  card(card_header("Squeeze something here? idk"), #Application Categories Breakdown"),total app count
       #style = "height: 100px;",
       plotOutput("Category_Waffle_Chart")),
  col_widths = c(3,9)
)

# Request_Count_and_Graph_Row <- card(
#   https://rstudio.github.io/bslib/articles/cards/index.html
# )

Main_Dashboard <- page_fluid(
  Total_Value_Boxes,
  Request_Count_and_Graph_Row,
  card(card_header("Total Amount Requested, Approved, and Allocated by Round"),
       plotlyOutput("Total_Amounts_Bar_Graph")),
  card(card_header("Amount Approved by Application? Fix dot size, add jitter"),
       plotlyOutput("Scatter_by_Filter")),
  card(card_header("Cumulative TITLE"),
       plotlyOutput("Cumulative_CIO_Graph")),
  card(card_header("Amount Requested vs Approved by Funding Category"),
       plotlyOutput("Funding_Cat_Lollipop")),
)