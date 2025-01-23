library(shiny)
library(dplyr)
library(tidyr)
library(readr)
library(bslib)
library(bsicons)
library(DT)
library(gridlayout)
library(janitor)
library(scales)
library(plotly)
library(hrbrthemes)
library(showtext)
library(thematic)
library(htmltools)
library(forcats)

#library(tidyverse) #TIDYVERSE IS FAT AND SHOULD NOT BE USED ON FINAL DEPLOY

#set to correct filepath to run app on your computer, comment out to deploy to server
setwd("C:/Users/17708/OneDrive - University of Virginia/!CIO Stuff/Appropriations Committee/Appropriations Dashboard/Appropriations-Dashboard")
#-----------

source('R/functions.R', local = TRUE)

#Load in appropriations committee data and cleans it
#df <- read_csv("Datacsv.csv") #TEST DATA - use for debugging until sufficient real data is collected
df <- read_csv("Funding_Master_Dataset.csv")
df <-clean_data(df)
