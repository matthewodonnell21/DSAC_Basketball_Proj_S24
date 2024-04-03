library(shiny)
library(tidyverse)
library(hoopR)  
library(tidymodels)

filter_choices <- c("Clutch", "FG_PCT", "PTS", "PF", "BLK", "STL", "TOV", "AST", "DREB", "OREB")

year <- c("1996-97", "1997-98", "1998-99", "1999-00", "2000-01", "2001-02", "2002-03", "2003-04", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10", "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16", "2016-17", "2017-18", "2018-19", "2010-20", "2020-21", "2021-22", "2022-23", "2023-24")

ui <- fluidPage(
  
  titlePanel("Clutch Players"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("filter", "Filter Data",
                  filter_choices),
      selectInput("year", "Choose Year",
                  year)
    ),
    mainPanel(
      tableOutput("player_clutch")
    )
  )
)

server <- function(input, output) {
  
   output$player_clutch <- read.csv(paste("clutch", gsub(pattern = "-.*", replacement = "", x = input$year), ".csv", sep = "")) |> 
    select(PLAYER_NAME, clutch_score, TEAM_ABBREVIATION, W, L, FG_PCT,
           PTS, PF, BLK, STL, TOV, AST, DREB, OREB) |> 
    rename(TEAM = TEAM_ABBREVIATION,
           Name = PLAYER_NAME,
           Clutch = clutch_score) |> 
    mutate(Clutch = Clutch * 100) |> 
    arrange(desc(!!sym(input$filter))) |> 
    renderTable()
  
}

shinyApp(ui = ui, server = server)
