

points.added.leaderboard = function(year = 2023, min.played = 0){
  if(!(year %in% 2002:2023)){
    return(data.frame())
  }
  
  file_path = paste("data/_", year, ".csv", sep = "")
  season_totals = read.csv(file_path) %>% filter(MIN > min.played)
  
  season_ratings = read.csv("data/pp_data.csv") %>% 
    filter(Season == year %% 2000)
  
  ppp = season_ratings$ppp
  orb.pct = season_ratings$orb.pct
  drb.pct = 1 - orb.pct
  ppFGM = season_ratings$ppFGM
  
  PA_2FGM = 2 - ppp
  PA_3FGM = 3 - ppp
  PA_FTM = 1 - (ppp*0.44)
  PA_FG.miss = -drb.pct*ppp
  PA_FT.miss = -0.44*ppp
  PA_assist = ppFGM - ppp
  PA_drb = orb.pct*ppp
  PA_orb = drb.pct*ppp
  PA_stls = ppp
  PA_blk = ppp*drb.pct
  PA_TO = -ppp
  
  season_totals = season_totals %>% mutate(totalPA = PA_2FGM*(FGM-FG3M) +
                               PA_3FGM*FG3M + 
                               PA_FTM*FTM + 
                               PA_FG.miss*(FGA-FGM) + 
                               PA_FT.miss*(FTA - FTM) +
                               PA_assist*AST + 
                               PA_drb*DREB +
                               PA_orb*OREB + 
                               PA_stls*STL +
                               PA_blk*BLK +
                               PA_TO*TOV,
                               PA.per.min = totalPA / MIN)
  
  season_totals = season_totals %>% 
    select(PLAYER_ID, PLAYER_NAME, TEAM_ABBREVIATION, MIN, totalPA, PA.per.min, 
           PTS, AST, OREB, DREB, BLK, STL, TOV, FG_PCT, FG3_PCT, FT_PCT)
  
  return(season_totals)
  
}
