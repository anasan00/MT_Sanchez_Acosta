# In this script,the Matching Event Data by Location Time and Type (MELTT) method
# is implemented for the tables of Belic Actions, Terrorist attacks and Attacks to 
# Towns.

# TO DO: If time create a quarto file or something easier to read 

# load libraries and packages 
#install.packages("meltt")
library(meltt)
library(readr)
library(dplyr)

# define functions 

create_taxbase <-  function(col){
  # function for creating the base of the taxonomy
  # define categories
  all_categories <- unique(c(
    ABforMELTT[[col]],
    APforMELTT[[col]],
    ATforMELTT[[col]]
  ))
  
  #define data sources
  data_sources <- c("ABforMELTT", "APforMELTT", "ATforMELTT")
  
  # create cross-product of categories and sources
  expanded_tax <- expand.grid(
    data.source = data_sources,
    base.categories = all_categories,
    stringsAsFactors = FALSE
  )
  
  return(expanded_tax)
}

force_datetime <- function(df){
  df$date <- as.Date(df$date)
  df$date <- format(df$date, "%Y-%m-%d 00:00:00")
  
  df$date <- as.Date(df$date, format = "%Y-%m-%d %H:%M:%S")
  
  return(df)
}

# load data 
ABforMELTT <- read_csv("ABforMELTT.csv")
APforMELTT <- read_csv("APforMELTT.csv")
ATforMELTT <- read_csv("ATforMELTT.csv")


# create taxonomies 

# initialize list for storing the taxonommies
tax_ls <- list()

# Related case taxonomy 
tax_ls$relcase_tax <- create_taxbase('relcase_tax')
tax_ls$relcase_tax$make_level1 <- ifelse(is.na(tax_ls$relcase_tax$base.categories), "isNA", "notNA")

# victims taxonomy
tax_ls$victims_tax <- create_taxbase('victims_tax')
tax_ls$victims_tax$make_level1 <- 
  ifelse(tax_ls$victims_tax$base.categories > 0, "victims", "no victims")


# format date columns 
ABforMELTT <- force_datetime(ABforMELTT)
APforMELTT <- force_datetime(APforMELTT)
ATforMELTT <- force_datetime(ATforMELTT)

# Remove rows with missing dates
ABforMELTT <- ABforMELTT %>% filter(!is.na(date)) #only 1 get removed (31.9)
APforMELTT <- APforMELTT %>% filter(!is.na(date))
ATforMELTT <- ATforMELTT %>% filter(!is.na(date))

# Redefine event column
ABforMELTT$event <- 1:nrow(ABforMELTT)
APforMELTT$event <- 1:nrow(APforMELTT)
ATforMELTT$event <- 1:nrow(ATforMELTT)
# apply meltt
output_siecvac <- meltt(ABforMELTT, APforMELTT,ATforMELTT,
                         taxonomies = tax_ls,
                         spatwindow = 5,
                         twindow = 2)
# plot output
plot(output_siecvac)

# save duplicates
meltt_dup <- meltt_duplicates(output_siecvac3)

# export 
uevents <- meltt_data(output_siecvac, columns = c("date","latitude", "longitude","relcase_tax","victims_tax",    
                                                   "clash_tax", "govattack_tax","guerrattack_tax","parattack_tax","posdattack_tax",'c_digo_dane_de_municipio','year'))
write.csv(uevents,"matchedevents.csv")


# TO DO: 
  # Validate method

