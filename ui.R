##################
####### UI #######
##################

ui <- fluidPage(
  tabsetPanel(
    
    # Tab for the application ---------------------------------
    tabPanel("Prescribing Map",
             # Title
             titlePanel("Prescribing Data London"),
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
             )),
    # Help tab ---------------------------------
    tabPanel("Help",
             documentation_tab()
             )
    )
)
