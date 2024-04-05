# Clutch Performance Analysis

## Motivation, Data, and Challenges

## Methodology 1

Our first method quantifies the "importance" of each box score statistic using a points-added approach. It relies upon the the leage-wide points per posession for a given season to estimate the impact of clutch actions. If we say the leage-wide points per possession for a given season was **PPP**, we calculate total points added in the clutch as follows...

#### Clear Ends to Possession
The values below are the easiest to calculate. When a box score stat represents a clear end to the possession, we can simply calculate the difference between how many points the possession ended in and what the league-wide expectation was. With respect to assists, we can estimate the points scored on the possession using that season's ratio of 2pt FGMs to 3pt FGMs. 
- **Points Added From 2pt FGM** = 2 - **PPP**
- **Points Added From 3pt FGM** = 3 - **PPP**
- **Points Added From Assits** = **Points Per FG Made** - **PP**
- **Points Added From Steal** = **PPP**
- **Points Added From Turnover** = -**PPP**
#### Rebounds
We can quantify the value of a defensive rebound by viewing it as taking away the opponent's chance to regain possession. There is an **ORB%** chance that the opponent would get another posession, which are expected points a defensive rebound takes away. Similarly, the value of an offensive rebound can be quantified by viewing it as a possession extension. There is a **DRB%** chance the opponent will end the possession after a missed shot, which is value an offensive rebound adds back. 
- **Points Added From DRB** = **ORB%** * **PPP**
- **Points Added From ORB** = **DRB%** * **PPP**
#### Unclear Ends to Possession

#### Free Throws

## Methodology 2



