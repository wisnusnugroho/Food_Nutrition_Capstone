function(input, output, session) {
  
  # Page 1 and Page 2
  filtered_data <- reactive({
    if (input$meal_type == "All") {
      return(food_clean)
    } else {
      return(food_clean %>% filter(Meal_Type == input$meal_type))
    }
  })
  
  # Page 2
  filtered_data_page2 <- reactive({
    data <- food_clean
    
    # Page 2
    if (input$meal_type_page2 != "All") {
      data <- data %>% filter(Meal_Type == input$meal_type_page2)
    }
    
    # Page 2
    if (input$category_type_page2 != "All") {
      data <- data %>% filter(Category == input$category_type_page2)
    }
    
    return(data)
  })
  
  # (Page 1)
  output$most_eaten_food <- renderValueBox({
    most_eaten_food <- filtered_data() %>%
      group_by(Food_Item) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      slice(1)
    
    valueBox(most_eaten_food$Food_Item, "Most Eaten Food", icon = icon("utensils"), color = "aqua")
  })
  
  # (Page 1)
  output$most_eaten_category <- renderValueBox({
    most_eaten_category <- filtered_data() %>%
      group_by(Category) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      slice(1)
    
    valueBox(most_eaten_category$Category, "Most Eaten Category", icon = icon("apple-alt"), color = "green")
  })
  
  # (Page 1)
  output$calories_range <- renderValueBox({
    calorie_range <- range(filtered_data()$Calories..kcal., na.rm = TRUE)
    valueBox(paste0(calorie_range[1], " - ", calorie_range[2]), "Calories Range", icon = icon("fire"), color = "orange")
  })
  
  # (Page 1)
  output$date_range <- renderValueBox({
    year_range <- range(as.numeric(format(filtered_data()$Date, "%Y")), na.rm = TRUE)
    valueBox(paste0(year_range[1], " - ", year_range[2]), "Date Range", icon = icon("calendar"), color = "purple")
  })
  
  # (Page 1) 
  output$top_foods_plot <- renderPlotly({
    top_foods <- filtered_data() %>%
      group_by(Food_Item) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      head(input$top_foods_slider)
    
    p <- ggplot(top_foods, aes(x = reorder(Food_Item, count), y = count)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      coord_flip() +
      labs(title = "Top Food Items Consumed", x = "Food Item", y = "Consumption Count")
    
    ggplotly(p)
  })
  
  # (Page 1)
  output$top_category_plot <- renderPlotly({
    top_categories <- filtered_data() %>%
      group_by(Category) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      head(input$top_category_slider)
    
    p <- ggplot(top_categories, aes(x = reorder(Category, count), y = count)) +
      geom_bar(stat = "identity", fill = "lightblue") +
      coord_flip() +
      labs(title = "Top Food Categories", x = "Category", y = "Consumption Count")
    
    ggplotly(p)
  })

  
  
  # (Page 1)
  output$table_data <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10, autoWidth = TRUE, scrollX = TRUE,scrollY = TRUE))
  })
  
  # (Page 2)
  output$meal_category_pie <- renderPlotly({
    pie_data <- filtered_data_page2() %>%
      count(Category) %>%
      mutate(percentage = n / sum(n) * 100)
    
    plot_ly(pie_data, labels = ~Category, values = ~percentage, type = "pie",
            textinfo = "label+percent", insidetextorientation = "radial") %>%
      layout(title = "Proporsi Kategori Makanan")
  })
  
  # (Page 2)
  output$meal_pie <- renderPlotly({
    pie_meal <- filtered_data_page2() %>%
      count(Meal_Type) %>%
      mutate(percentage = n / sum(n) * 100)
    
    plot_ly(pie_meal, labels = ~Meal_Type, values = ~percentage, type = "pie",
            textinfo = "label+percent", insidetextorientation = "radial") %>%
      layout(title = "Proporsi Tipe Makanan")
  })
  
  # (Page 2)
  output$nutrition_analysis_plot <- renderPlotly({
    plot_ly(filtered_data_page2(), x = ~Calories..kcal., y = ~Protein..g., type = "scatter", mode = "markers",
            marker = list(size = 10, color = "blue")) %>%
      layout(title = "Calories vs Protein", xaxis = list(title = "Calories (kcal)"), yaxis = list(title = "Protein (g)"))
  })
  
  # (Page 2)
  output$food_trend_plot <- renderPlotly({
    trend_data <- filtered_data_page2() %>%
      group_by(Date) %>%
      summarise(total_foods = n())
    
    plot_ly(trend_data, x = ~Date, y = ~total_foods, type = 'scatter', mode = 'lines', line = list(color = 'orange')) %>%
      layout(title = "Trend of Food Consumption Over Time", xaxis = list(title = "Date"), yaxis = list(title = "Number of Foods Consumed"))
  })
  
  # (Page 2)
  output$correlation_heatmap <- renderPlotly({
    numeric_cols <- food_clean %>%
      select_if(is.numeric)
    
    corr_matrix <- cor(numeric_cols, use = "complete.obs")
    
    corr_data <- as.data.frame(as.table(corr_matrix))
    
    p <- ggplot(corr_data, aes(Var1, Var2, fill = Freq)) +
      geom_tile() +
      scale_fill_gradient2(low = "blue", high = "red", mid = "yellow", midpoint = 0, 
                           limit = c(-1, 1), space = "Lab", name = "Correlation") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = "Correlation between Nutritional Features", x = "", y = "")
    
    ggplotly(p)
  })

  # (Page 3)
  output$dataset_table <- renderDT({
    datatable(food_clean, options = list(pageLength = 10, autoWidth = TRUE, scrollX = TRUE,scrollY = TRUE))
  })
  
}