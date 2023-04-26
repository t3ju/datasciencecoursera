complete <- function(directory,  id = 1:332) {
  
  # Format number with fixed width and then append .csv to number
  fielnm <- paste0(directory, '/', formatC(id, width=3, flag="0"), ".csv" )
  
  # Reading in all files and making a large data.table
  lst <- lapply(fielnm, data.table::fread)
  dt <- rbindlist(lst)
  
  return(dt[complete.cases(dt), .(nobs = .N), by = ID])
  
}

#Example usage
complete(directory = 'C:/Users/tejpal.jangir/Documents/R Folder/specdata', id = 20:30)
