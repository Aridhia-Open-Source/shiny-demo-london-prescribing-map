##################
##### GLOBAL #####
##################

# Load libraries
library(shiny)
library(shinydashboard)
library(dplyr)
library(survival)
library(ggplot2)
library(DT)
library(dygraphs)
library(ggvis)

# Source all the code in Code folder
for (file in list.files("code", full.names = TRUE)){
  source(file, local = TRUE)
}


## Read the data 
df <- read.csv("data/presc_bnf_ccg_summary_demo_ldn.csv")

df$case[df$case == "diabetes"] <- "Systemic Corticosteroids"
df$case[df$case == "statins"] <- "Anticholinergics"
df$case[df$case == "antidepressants"] <- "Immunomodulators"

## A function that creates the map's title
create_maps_title <- function(maps_data, year = NULL, var = NULL, drug = NULL, c_splines) {
  # Set colours
  g_col = "#4ad254"
  o_col = "#ffb732"
  r_col = "#ee2a2a"
  
  # Create title's HTML code
  if (var == "items_perc"){
    lab1 <- paste0("Percentage of ", drug, " prescribed in ", year, " across populations in London")
    title <- paste0("<h3> ", lab1, "</h3>", 
                    "<h4>", "Groups: ", "<br>",
                    " <font color='", g_col, "'> < £", round(c_splines[2], 2), "% </font>", "<br>",
                    " <font color='", o_col, "'> £", round(c_splines[2], 2), " < £", round(c_splines[3], 2), "% </font>", "<br>",
                    " <font color='", r_col, "'> > £", round(c_splines[3], 2), "%</font>",
                    "</h4>"
    )
  } else if (var == "act_cost_perc") {
    lab1 <- paste0("Average cost (£ per person) of ", drug, " prescribed in ", year, " corrected to CCG population sizes across London")
    title <- paste0("<h3> ", lab1, "</h3>", 
                    "<h4>", "Groups: ", "<br>",
                    " <font color='", g_col, "'> < £", round(c_splines[2], 2),"</font>", "<br>",
                    " <font color='", o_col, "'> £", round(c_splines[2], 2), " < ", round(c_splines[3], 2), "</font>", "<br>",
                    " <font color='", r_col, "'> £", round(c_splines[3], 2), "+</font>",
                    "</h4>"
    )
  }
  
  # Return title
  return(title)    
}      


