library(shiny)

ui <- fluidPage(
  
  titlePanel("Clutch Players"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("player", "Player Selection:",
                  player_names, multiple = T),
      selectInput("filter", "Filter Data",
                  filter_choices)
    ),
    mainPanel(
      tableOutput("player_clutch")
    )
  )
)

server <- function(input, output) {
  
  output$player_clutch <- player_final |> 
    filter(PLAYER_NAME %in% input$player) |> 
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
