library(shiny)
library(tidyverse)
library(hoopR)  
library(tidymodels)
library(shinythemes)

filter_choices <- c("Clutch", "FG_PCT", "PTS", "PF", "BLK", "STL", "TOV", "AST", "DREB", "OREB")

year <- c("1996-97", "1997-98", "1998-99", "1999-00", "2000-01", "2001-02", "2002-03", "2003-04", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10", "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16", "2016-17", "2017-18", "2018-19", "2019-20", "2020-21", "2021-22", "2022-23", "2023-24")

excluded <- c("GROUP_SET", "PLAYER_NAME", "NICKNAME", "TEAM_ABBREVIATION")

ui <- fluidPage(theme = shinytheme("darkly"),
  
  titlePanel("Clutch Players"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("filter", "Filter Data",
                  filter_choices),
      selectInput("year", "Choose Year",
                  year),
      numericInput("minutes", "Choose Minute Minimum", 0)
    ),
    mainPanel(
      tableOutput("player_clutch")
    )
  )
)

server <- function(input, output) {
  
   d1 <- reactive(nba_leaguedashplayerclutch(season = year_to_season(gsub(pattern = "-.*", replacement = "", x = input$year))) |> 
                    as.data.frame() |> 
                    rename_with(.cols = everything(), .fn = ~gsub(pattern = "LeagueDashPlayerClutch.", replacement = "", x = .)) |> 
                    mutate_if(is.character, as.numeric) |> 
                    select(-excluded))
   
   d2 <- reactive(nba_leaguedashplayerclutch(season = year_to_season(gsub(pattern = "-.*", replacement = "", x = input$year))) |>
                    as.data.frame() |> 
                    rename_with(.cols = everything(), .fn = ~gsub(pattern = "LeagueDashPlayerClutch.", replacement = "", x = .)) |> 
                    mutate(PLAYER_ID = as.numeric(PLAYER_ID)) |>
                    select(PLAYER_ID, PLAYER_NAME, NICKNAME, TEAM_ABBREVIATION) |>
                    left_join(d1(), join_by(PLAYER_ID)))
   
   weights <- reactive(lm(W_PCT ~ FG_PCT + PTS + PF + BLK + STL + TOV + AST + DREB + OREB, data = d2()) |> 
                         tidy() |> 
                         slice(2:10) |> 
                         select(estimate) |> 
                         data.matrix())
   
   final <- reactive(data.matrix(select(d2(), FG_PCT, PTS, PF, BLK, STL, TOV, AST, DREB, OREB)) %*% weights() |>
     as.data.frame() |> 
     cbind(d2()) |> 
     rename(clutch_score = estimate))
  
   output$player_clutch <- renderTable({
     
     final_data <- data.frame(final() |> 
       filter(MIN > input$minutes) |> 
       select(PLAYER_NAME, clutch_score, TEAM_ABBREVIATION, W, L, FG_PCT,
                                  PTS, PF, BLK, STL, TOV, AST, DREB, OREB) %>%
       rename(TEAM = TEAM_ABBREVIATION,
              Name = PLAYER_NAME,
              Clutch = clutch_score) %>%
       mutate(Clutch = Clutch * 100) %>%
       arrange(desc(!!sym(input$filter))))
     
     final_data
       
   })

}

shinyApp(ui = ui, server = server)
