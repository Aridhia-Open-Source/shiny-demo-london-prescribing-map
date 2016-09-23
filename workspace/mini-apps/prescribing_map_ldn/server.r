
# Set miniapp option
options(dplyr.length = 1e10)



# Miniapp server function
shinyServer(function(input, output, session) {
  
  ## Read the data 
  df <- xap.read_table("presc_bnf_ccg_summary_demo_ldn")
  #df <- read.csv("//aridhia.net/files/shared/Data Science Team/Demos/data/miniapps_demo/archive/presc_bnf_ccg_summary_demo_ldn2.csv")
  
  df$case[df$case == "diabetes"] <- "Systemic Corticosteroids"
  df$case[df$case == "statins"] <- "Anticholinergics"
  df$case[df$case == "antidepressants"] <- "Immunomodulators"
  
  ## Filter the data according to the values of the widgets
  select_data <- reactive({
    
    # Get the widgets values
    yr <- input$year 
    var <- input$var
    drug <- input$drug
    
    # Filter the data
    selected_data <-  df  %>%
    	filter(year == yr & case == drug) %>%
      	select(ccg_code, id, year, case, act_cost, nic, ccg13nm, long, lat, order, group, items_perc, act_cost_perc) 
    
    # Select variable to be plotted
    if (var == "items_perc"){
      selected_data <- selected_data %>% mutate(var = items_perc)
    } 
    else if (var == "act_cost_perc"){
      selected_data <- selected_data %>% mutate(var = act_cost_perc)
    }
    
    # Return the selected data
    selected_data
    
  })
  
  ## Summarise the data   
  summarise_data <- reactive({
    
    # Get selected data
    selected_data <- select_data()
    
    # Group the data by CCG and calculate avg value of the selected variable
    summarised_data <- selected_data %>%
      group_by(ccg_code) %>%
      summarise(var=mean(var, na.rm = TRUE)) %>%
      arrange(var)
    
    # Return
    summarised_data
    
  })
      
  ## Get splines to segment and colour data by
  get_splines <- reactive({
    
    # Get selected data and summarised data
    selected_data <- select_data()
    c_palette <- summarise_data()
    
    # Define quartile splines to segment and colour data by 
    c_splines <- quantile(c_palette$var, probs = seq(0, 1, 1/3), na.rm = TRUE) 
    
    # Return splines
    c_splines
  })
      
  ## Add the colour palette to the selected dataset   
  add_palette <- reactive({
    
    # Get selected data, summarised data as a basis for the colour palette and the quartile splines
    selected_data <- select_data()
    c_palette <- summarise_data()
    c_splines <- get_splines()
    
    # Define colour groups
    colour_group <- cut(
      c_palette$var, 
      c(0, c_splines[2:3], max(c_palette$var)), 
      labels=c("low", "moderate", "high")
    )
    
    c_palette$col_grp <- colour_group
    
    
    # Define gradient colours within each of the colour groups        
    c_palette$col_code <- c(colorRampPalette(c("#c8f1cb", "#4ad254"))(nrow(c_palette%>% filter(col_grp=="low"))),
                            colorRampPalette(c("#ffdb99","#ffb732"))(nrow(c_palette%>% filter(col_grp=="moderate"))),
                            colorRampPalette(c("#f69494","#ee2a2a"))(nrow(c_palette%>% filter(col_grp=="high"))))
    
    # Combine te selected data with the colour palette
    selected_data <- left_join(selected_data, c_palette)
    
    # Return the resulted data frame
    selected_data
    
  })
  
  ## Add the map title to the UI
  output$map_title <- renderUI(
      HTML(
        create_maps_title(add_palette(), input$year, input$var, input$drug, get_splines())       
      )
    )
  
  ## Tooltip function. x is the ggvis object that is currently triggering the tooltip
  map_tooltip <- function(x) {
    
    # Return an empty tooltip if x is empty
    if(is.null(x)) return(NULL)
	
    # Retrieve the code of the ccg that triggered the tooltip
    selected_ccg_code <- x$ccg_code

    # Get selected data
    selected_data <- add_palette()

	# Filter ans summarise the selected data according to the retrieved CCG code
    ccg <- selected_data %>%
      filter(ccg_code == selected_ccg_code) %>%
      group_by(
        ccg_code, 
        ccg13nm
      ) %>% 
      summarise(
        items = round(mean(items_perc, na.rm=T), 2),
        avg_cost = round(mean(act_cost_perc, na.rm=T), 2)
      ) 

    ccg <- unique(ccg)
	
    # Create the HTML code for the tooltip
    tip <- paste0("CCG: ", ccg$ccg13nm, "<br>",
                  "Items (%): ", ccg$items, "<br>",
                  "Avg cost (£): ", ccg$avg_cost, "<br>"
          		  )
      
    # Return tooltip
    return(tip)
  }
  
  ## Create ggvis interactive map
  
  ## Bind interactive map to the UI
  ggvis(add_palette %>% arrange(order) %>% group_by(ccg_code, group)) %>%
    layer_paths(x = ~long, y = ~lat, fill := ~col_code, fillOpacity := 0.8, fillOpacity.hover := 1,
                strokeWidth := 0.5, strokeWidth.hover := 2) %>%  
    add_tooltip(map_tooltip, 'hover') %>%
    hide_axis("x") %>% 
    hide_axis("y") %>%
    set_options(duration = 500) %>%
    bind_shiny("map_plot")
    
  output$table <- renderDataTable({
    
    data <- select_data()
    
    display_data <- data %>%
      group_by(ccg_code, id, year, case, act_cost, nic, ccg13nm, items_perc, act_cost_perc) %>%
      summarise()
    
    datatable(display_data, colnames = c('CCG Code', 'Id', 'Year', 'Case', 'Actual Cost', 'Net Ingredient Cost', 'CCG Name',
                                         'Percentage of Items', 'Percentage of Actual Cost')
              )
    
  })
      
})

## A function that creates the map's title
create_maps_title <- function(maps_data, year = NULL, var = NULL, drug = NULL, c_splines) {
  
  # Set colours
  g_col = "#4ad254"
  o_col = "#ffb732"
  r_col = "#ee2a2a"
  
  # Set names to appear for certain options
  #if (drug=="antidepressants"){
  #  drug = "anti-depressants"
  #}
  #else if (drug=="diabetes"){
  #  drug = "diabetic drugs"
  #}
  
  # Create title's HTML code
  if (var=="items_perc"){
    lab1 <- paste0("Percentage of ", drug, " prescribed in ", year, " across populations in London")
    title <- paste0("<h3> ",
                   lab1,
                   "</h3>",
                   "<h4>",
                   "Groups: ",
                   " <font color='",g_col,"'>0 < ", round(c_splines[2],2),"%</font>",
                   " <font color='",o_col,"'>", round(c_splines[2],2), " < ", round(c_splines[3],2),"%</font>",
                   " <font color='",r_col, "'>", round(c_splines[3],2), "% +</font>",
                   "</h4>"
    )
  }
  else if (var=="act_cost_perc"){
    lab1 <- paste0("Average cost (£ per person) of ", drug, " prescribed in ", year, " corrected to CCG population sizes across London")
    title <- paste0("<h3> ",
                   lab1,
                   "</h3>",
                   "<h4>",
                   "Groups: ",
                   " <font color='",g_col,"'>£0 < ", round(c_splines[2],2),"</font>",
                   " <font color='",o_col,"'>£", round(c_splines[2],2), " < ", round(c_splines[3],2),"</font>",
                   " <font color='",r_col, "'>£", round(c_splines[3],2), "+</font>",
                   "</h4>"
    )
  }
  
  # Return title
  return(title)    
}      
      
      
      
      
      