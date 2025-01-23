SideBar_Settings <- accordion(
  open=FALSE, 
  multiple=FALSE,
  accordion_panel(
    "CIO Filters", icon = bsicons::bs_icon("menu-app"),
    navset_card_underline(
      nav_panel(title = "CIO",
                selectizeInput(
                  inputId = "CIO_Selected",
                  label = NULL,
                  choices = c("All CIOs", unique(df$CIO_Name)),
                  options = list(
                    dropdownParent = 'body'
                    )
                  )
                ),
      nav_panel(title = "Category",
                checkboxGroupInput("Categories_Selected", NULL, 
                                   choices = unique(unlist(df$CIO_Category))
                )),
      #nav_spacer(),
      nav_item(
        tooltip(
          bs_icon("info-circle"),
          "Cannot filter by CIO and Category simultaneously ", #Can't figure out how to word this best
          placement = "right"
        )
      )
    ),
  ),
  accordion_panel(
    "Rolling Round", icon = bsicons::bs_icon("sliders"),
    accordion(
      multiple=FALSE,
      accordion_panel("Year",
                      multiple=FALSE,
                      checkboxGroupInput("yearInput", NULL, 
                                         choices = unique(df$Year)
                                         )
                      ),
      accordion_panel("Round",
                      multiple=FALSE,
                      checkboxGroupInput("roundInput", NULL, 
                                         choices = unique(df$Round_RRX)
                                         )
                      ),
      accordion_panel("Semester",
                      multiple=FALSE,
                      checkboxGroupInput("semesterInput", NULL, 
                                         choices = unique(df$Semester)
                      )
      )
    )
  )
)


#No idea why the following code works, found it here https://stackoverflow.com/questions/77196229/nested-accordion-does-not-seem-adhere-to-multiple-false-parameter
#Allows the sidebar to have nested accordion tabs - bslib otherwise can't handle them properly
tagQ <- htmltools::tagQuery(SideBar_Settings)
tagQ$
  find(".accordion-collapse.collapse")$
  each(function(el, i) {
    # save all parents
    parents <- el$attribs[names(el$attribs) == "data-bs-parent"] 
    # remove all parents
    el$attribs <- el$attribs[names(el$attribs) != "data-bs-parent"]
    # append the "true" parent, which is the first one
    tagAppendAttributes(el, `data-bs-parent` = unlist(parents)[1])
    # return edited tag
    el
  })$
  allTags()

Reset_Button <- actionButton(
  "reset_btn", "Reset Filters"
)

Main_Sidebar <- page(
  tagQ$allTags(),
  Reset_Button
)