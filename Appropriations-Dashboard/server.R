function(input,output,session){
  #bs_themer() #Temporary! Allows for easy theming
  bs_theme() #sets to bootstrap theme -> https://rstudio.github.io/bslib/articles/theming/index.html
  thematic_shiny()
  
  #Allow access to server files for reactive elements
  source('Server/Reactive_Data.R', local = TRUE)
  source('Server/Outputs.R', local = TRUE) 
  source('Server/Observations.R', local = TRUE)
}