####################
##### HELP TAB #####
####################

documentation_tab <- function() {
  tabPanel("Help",
           fluidPage(width = 12,
                     fluidRow(column(
                       6,
                       h3("London Prescribing Map"), 
                       p("Mini-app to visualise drug prescription across various spatial district data zones in London. It contains prescribing data aggregated by Clinical Commissioning 
                         Group (CCG) regions in London between 2011-2013. Data that can be visualised includes the percentage of items prescribed corrected to the population and the cost 
                         per person. Drug types that can be compared includes statins, anti-depressants and diabetes drugs."),
                       h3("How to use the mini-app"),
                       p("This RShiny Mini-app has two tabs, this is the 'Help' tab, which contains information and instructions about the app itself. The other tab is the app tab, called 
                         'Prescribing Map'."),
                       p("In the app tab, you will see an interactive London map in the main panel. Hover over the different regions to display more information about the prescribing.
                         Under the map, there is the data table from which the information in the map has been exctracted."),
                       p("Using the options in the left-hand side bar you can:"),
                       tags$ol(
                         tags$li("Select a different year to visualize"),
                         tags$li("Select to variable to visualize (% Items or Average Cost)"),
                         tags$li("Select the drug to visualise (Systemic corticosteroids, Immunomodulators, Anticholinergics)")
                       )
                     ),
                     column(
                       6,
                       h3("Walkthrough video"),
                       tags$video(src="london-prescribing.mp4", type = "video/mp4", width="100%", height = "350", frameborder = "0", controls = NA),
                       p(class = "nb", "NB: This mini-app is for provided for demonstration purposes, is unsupported and is utilised at user's 
                       risk. If you plan to use this mini-app to inform your study, please review the code and ensure you are 
                       comfortable with the calculations made before proceeding. ")
                       
                     ))
                     
                     
                     
                     
           ))
}