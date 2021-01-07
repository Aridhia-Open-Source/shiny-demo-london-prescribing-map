
library(shiny)
library(shinydashboard)
library(dplyr)
library(survival)
library(ggplot2)
library(DT)
library(dygraphs)
library(ggvis)

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
                    "<h4>", "Groups: ",
                    " <font color='", g_col, "'>0 < ", round(c_splines[2], 2), "%</font>",
                    " <font color='", o_col, "'>", round(c_splines[2], 2), " < ", round(c_splines[3], 2), "%</font>",
                    " <font color='", r_col, "'>", round(c_splines[3], 2), "% +</font>",
                    "</h4>"
    )
  } else if (var == "act_cost_perc") {
    lab1 <- paste0("Average cost (£ per person) of ", drug, " prescribed in ", year, " corrected to CCG population sizes across London")
    title <- paste0("<h3> ", lab1, "</h3>",
                    "<h4>", "Groups: ",
                    " <font color='", g_col, "'>£0 < ", round(c_splines[2], 2),"</font>",
                    " <font color='", o_col, "'>£", round(c_splines[2], 2), " < ", round(c_splines[3], 2), "</font>",
                    " <font color='", r_col, "'>£", round(c_splines[3], 2), "+</font>",
                    "</h4>"
    )
  }
  
  # Return title
  return(title)    
}      


prescribing_text <- function(){
  text <- "
  <p style='color: #585858;' align='justify'> 
  <i> 
    Three drug types that are topical and frequently in the news are statins, anti-depressants and diabetes drugs.
    </p>
    <p>
      Statins are medicines which lower the level of cholesterol in the blood. High levels of 'bad cholesterol' can increase the risk
      of having a heart attack or a stroke and of developing cardiovascular disease. <a href=\"http://www.bbc.co.uk/news/health-18101554\">BBC News</a>
      The National Institute for Health and Care Excellence (NICE) says the scope for offering this treatment should be widened to
      save more lives. The NHS currently spends about Â£450m a year on statins. If the draft recommendations go ahead, this bill
      will increase substantially, although the drugs have become significantly cheaper over the years. It is not clear precisely how
      many more people would be eligible for statin therapy than now, but NICE says it could be many hundreds of thousands or
      millions. <a href=\"http://www.bbc.co.uk/news/health-26132758\" target=\"_blank\">BBC News</a>,
    </p>
    <p>
      The use of antidepressants rose significantly in England during the financial crisis and subsequent recession, with 12.5m
      more pills prescribed in 2012 than in 2007, a study has found. Researchers from the Nuffield Trust and the Health
      Foundation identified a long-term trend of increasing prescription of antidepressants, rising from 15m items in 1998 to 40m
      in 2012. But the yearly rate of increase accelerated during the banking crisis and recession to 8.5%, compared to 6.7%
      before it. <a href\"http://www.theguardian.com/society/2014/may/28/-sp-antidepressant-use-soared-during-recession-uk-study\">The Guardian</a>
      The report also found that rises in unemployment were associated with significant increases in the number of
      antidepressants dispensed and that areas with poor housing tended to see significantly higher antidepressant use.
    </p>
    <p>
      It is estimated that more than 1 in 17 people in the UK have diabetes. In 2014, 3.2 million people had been diagnosed, and
      by 2025 this number is estimated to grow to 5 million.
      <a href=\"https://www.diabetes.org.uk/Documents/About%20Us/Statistics/Diabetes-key-stats-guidelines-April2014.pdf\">diabetes.org</a>
      Diabetes, when present in the body over many years, can give rise to all sorts of complications. These include heart
      disease, kidney disease, retinopathy and neuropathy. Diabetes is the leading cause of amputations.
      <a href =\"http://www.diabetes.co.uk/diabetes-and-amputation.html\">diabetes.co.uk</a>
  </i>
  </p>"
  
  return(text) 
}
