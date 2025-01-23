clean_data <- function(df){
  clean_column_name <- function(name) {
    name <- trimws(name) # Remove leading and trailing spaces
    name <- gsub("\\s+", "_", name) # Replace spaces with underscores
    name <- gsub("[^a-zA-Z0-9_]", "", name) # Remove special characters
    return(name)
  }
  
  # Clean the column names
  colnames(df) <- sapply(colnames(df), clean_column_name)
  
  # Convert money columns to numeric data types
  money_columns <- grep("Amount|Requested|Approved|Difference|Expenses", colnames(df), value = TRUE)
  df[money_columns] <- lapply(df[money_columns], function(x) as.numeric(gsub("[\\$,]", "", x)))
  
  # Convert percentage columns to numeric data types
  percentage_columns <- grep("Rate", colnames(df), value = TRUE)
  df[percentage_columns] <- lapply(df[percentage_columns], function(x) as.numeric(gsub("%", "", x)))
  
  # Convert Date_RR_apps_closed column to date datatype
  df$Date_RR_apps_closed <- as.Date(df$Date_RR_apps_closed, format="%m/%d/%Y")
  
  #Adds a column that concatenates Semester, Round, and Year
  df <- df %>%
    mutate(Semester_Round_Year = paste(Semester, Round_RRX, Year, sep=" ", collapse=NULL)) %>%
    mutate(Semester_Round_Year = gsub(" (RR[0-9]+) (.*)", " \\1, \\2", Semester_Round_Year)) %>%
    select(1:6, Semester_Round_Year, everything())
  
  df$CIO_Category <- strsplit(df$CIO_Category, split = ",")
  
  return(df)
}
