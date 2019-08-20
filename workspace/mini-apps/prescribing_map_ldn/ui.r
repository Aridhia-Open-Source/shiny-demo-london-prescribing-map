
xap.require(
  "shiny",
  "dplyr",
  "shinydashboard",
  "survival",
  "ggplot2",
  "DT",
  "dygraphs",
  "ggvis"
)

############################################################
######################### meta data ########################
############################################################
#'@name prescribing_text
#'
#'
prescribing_text <- function(){
  text <- "<p style='color: #585858;' align='justify'> 
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

############################################################
######################### plot data ########################
############################################################

shinyUI(fluidPage(
  titlePanel("Prescribing data London"),
  fluidRow(
    column(width = 3,
      wellPanel(
        sliderInput("year", "Select year to visualise: ",
                    min = 2011, max = 2013, value = 2011, 
                    animate = FALSE, sep = ""),
        br(),             
        selectInput("var", label = "Select variable to visualise", 
                    choices = list("% Items" = "items_perc", "Average cost (£)" = "act_cost_perc"), 
                    selected = "items_perc"),
        br(),
        radioButtons("drug",  label="Select the drug to visualise",
                     choices = list("Systemic Corticosteroids", "Immunomodulators", "Anticholinergics"),
                     selected = "Anticholinergics"),
        br(),
        HTML("<button type='button' class='btn btn-info' data-toggle='collapse' data-target='#text_more'>Info</button>"),
        br(),
        div(id = "text_more", class = "collapse", 
            h4('Metric metadata'), HTML(prescribing_text()))
      )
    ),
    column(9,
      wellPanel( 
        htmlOutput("map_title", inline=F),
        ggvisOutput("map_plot"),
        br(),
        dataTableOutput(outputId="table")
      )
    )
  )
))

