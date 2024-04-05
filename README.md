# Clutch Performance Analysis

## Motivation, Data, and Challenges

## Methodology 1

Our first method quantifies the "importance" of each box score statistic using a points-added approach. It relies upon the the leage-wide points per posession for a given season to estimate the impact of clutch actions. If we say the leage-wide points per possession for a given season was **PPP**, we calculate total points added in the clutch as follows...

#### Clear Ends to Possession
- **Points Added From 2pt FGM** = 2 - **PPP**
- **Points Added From 3pt FGM** = 3 - **PPP**
- **Points Added From Assits** = **Points Per FG Made** - **PP**
- **Points Added From Steal** = **PPP**
- **Points Added From Turnover** = -**PPP**

## Methodology 2



