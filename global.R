library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(DT)
library(plotly)
library(lubridate)
library(tidyr)

# Load data
food <- read.csv("daily_food_nutrition_dataset.csv", stringsAsFactors = TRUE, encoding = "latin1")

# Data Cleaning
food_clean <- food %>%
  mutate(User_ID = as.character(User_ID),
         Date = as.Date(Date, format = "%Y-%m-%d"),
         Meal_Type = as.character(Meal_Type),
         Category = as.character(Category)
  )
