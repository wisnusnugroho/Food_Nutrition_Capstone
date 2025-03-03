dashboardPage(
  dashboardHeader(title = "Food Nutrition Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Overview", tabName = "page1", icon = icon("table")),
      menuItem("Nutrition Portion & Analysis", tabName = "page2", icon = icon("pie-chart")),
      menuItem("Dataset", tabName = "page3", icon = icon("database")),
      menuItem("External Link", tabName = "page4", icon = icon("link"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Page 1 - Data Overview
      tabItem(
        tabName = "page1",
        fluidRow(
          valueBoxOutput("most_eaten_food", width = 3),
          valueBoxOutput("most_eaten_category", width = 3),
          valueBoxOutput("calories_range", width = 3),
          valueBoxOutput("date_range", width = 3)
        ),
        fluidRow(
          box(title = "Meal Type", status = "primary", width = 12,
              selectInput("meal_type", "Select Meal Type",
                          choices = c("All", unique(food_clean$Meal_Type)), 
                          selected = "All")
          )
        ),
        fluidRow(
          box(title = "Top Food Items Consumed", status = "primary", width = 6,
              plotlyOutput("top_foods_plot"),
              sliderInput("top_foods_slider", "Top N Foods", min = 1, max = 50, value = 10)
          ),
          box(title = "Top Category Food", status = "primary", width = 6,
              plotlyOutput("top_category_plot"),
              sliderInput("top_category_slider", "Top N Categories", min = 1, max = 7, value = 5)
          )
        ),
        fluidRow(
          box(title = "Food Data Table", status = "primary", width = 12,
              DT::dataTableOutput("table_data")
          )
        )
      ),
      
      # Page 2 - Nutrition Portion & Analysis
      tabItem(
        tabName = "page2",
        h2("Nutrition Portion & Analysis"),
        
        # Row 1: Meal Type and Category Selection
        fluidRow(
          column(width = 6,
                 box(title = "Meal Type", status = "primary", width = 12,
                     selectInput("meal_type_page2", "Select Meal Type",
                                 choices = c("All", unique(food_clean$Meal_Type)), 
                                 selected = "All")
                 )
          ),
          column(width = 6,
                 box(title = "Food Category", status = "primary", width = 12,
                     selectInput("category_type_page2", "Select Food Category",
                                 choices = c("All", unique(food_clean$Category)), 
                                 selected = "All")
                 )
          )
        ),
        
        # Row 2: Proporsi (Pie Chart)
        fluidRow(
          column(width = 6,
                 plotlyOutput("meal_category_pie")
          ),
          column(width = 6,
                 plotlyOutput("meal_pie")
          ),
        ),
        
        # Row 3: Nutritional Analysis Plot
        br(),fluidRow(
          
          column(width = 12,
                 plotlyOutput("nutrition_analysis_plot")
          ),
          
        ),
        
        # Row 4: Trend aja
        br(),fluidRow(
          column(width = 12,
                 plotlyOutput("food_trend_plot")
          ),
        ),
        # Row 5: Heatmap
        br(),fluidRow(
          
          column(width = 12,
                 plotlyOutput("correlation_heatmap")
          ),
        )
      ),
      
      # Page 3 - Dataset Display 
      tabItem(
        tabName = "page3",
        h2("Data Visualization Capstone Project"),
        p("Dataset ini mencatat asupan makanan harian dan nilai nutrisi individu, membantu dalam analisis diet terkait kesehatan dan kesejahteraan. Setiap entri merepresentasikan makanan yang dikonsumsi oleh seorang pengguna pada tanggal tertentu, termasuk rincian kandungan nutrisinya."),
        p("Berikut Link dataset yang digunakan: ",
          a("Kaggle Dataset", 
            href="https://www.kaggle.com/datasets/adilshamim8/daily-food-and-nutrition-dataset/data", target = "_blank")),
        br(),
        h3("Data Daily Food & Nutrition"),
        fluidRow(
          box(
            width = 12,
            title = "Data Daily Food & Nutrition",
            status = "primary", 
            DT::dataTableOutput("dataset_table")  
          )
        )
      ),
      
      # Page 4 - External Link 
      tabItem(
        tabName = "page4",
        h2("External Link"),
        p("Click below to visit the link."),
        tags$a(href = "https://rpubs.com/ninu", "Go to Example", target = "_blank")
      )
    ) 
  ) 
)