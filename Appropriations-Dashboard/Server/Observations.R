#--------------------#
# Reset Button Logic #
#--------------------#
observeEvent(input$reset_btn, {
  #Reset CIO Filters
  updateSelectizeInput(session, "CIO_Selected", selected="All CIOs")
  updateCheckboxGroupInput(session, "Categories_Selected", selected=character(0))
  #Reset Rolling Round filters
  updateCheckboxGroupInput(session, "yearInput", selected=character(0))
  updateCheckboxGroupInput(session, "roundInput", selected=character(0))
  updateCheckboxGroupInput(session, "semesterInput", selected=character(0))
})


#--------------------------------------------------#
# Makes sure only 1 type of CIO filter is selected #
#--------------------------------------------------#
observeEvent(input$CIO_Selected, {
  updateCheckboxGroupInput(session, "Categories_Selected", selected=character(0))
})

observeEvent(input$Categories_Selected, {
  updateSelectizeInput(session, "CIO_Selected", selected="All CIOs")
})