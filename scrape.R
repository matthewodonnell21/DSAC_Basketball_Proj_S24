library(hoopR)

# Change this variable to scrape a different year's data
for(year in 2:22){
  
  clutch_totals = data.frame(nba_leaguedashplayerclutch(season = year_to_season(year), 
                                                        per_mode = "Totals"))
  
  colnames(clutch_totals) <- sub("LeagueDashPlayerClutch.", "", 
                                 colnames(clutch_totals))
  
  clutch_totals <- clutch_totals[, -c(1, 4, 6)]
  
  file_path = paste("data/", year, ".csv", sep = "")
  
  write.csv(clutch_totals, file = file_path)
}

