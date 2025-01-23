source('UI/Sidebar_UI.R', local = TRUE)
source('UI/Main_Dashboard_UI.R', local = TRUE)
source('UI/Data_UI.R', local = TRUE)

page_navbar(
  title = "UVA Student Council",
  id = "nav",
  
  sidebar = sidebar(
    # conditionalPanel(
    #   "input.nav === 'SAF Funding Dashboard'", #THIS DOESN'T WORK FOR SOME REASON!?!
    #   Main_Sidebar
    # ),
    # conditionalPanel(
    #   "input.nav === 'Page 2'",
    #   SideBar_Settings
    # ),
    # conditionalPanel(
    #   "input.nav === 'Data'",
    #   Main_Sidebar
    # ),
    Main_Sidebar,
    width = "18%"
  ),
  
  nav_panel("SAF Funding Dashboard", Main_Dashboard),
  nav_panel("Data", Data_UI),
  
  nav_spacer(),
  nav_menu(
    title = "More",
    align = "right",
    nav_panel("How to", "Page with general tips on how to use/interpret the dashboard? Think of better title."), #Consider Moving to nav_panel?
    nav_panel("References/acknowledgements", "Version alpha 3.0 built by Scott Dunn \n This build is intended for demo and debugging purposes only. All data currently provided is fake." )
      #Add link to SAF Guidelines, student council website, etc?
  )
)