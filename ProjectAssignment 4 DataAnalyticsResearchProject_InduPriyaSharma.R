library(tidyverse)
library(ggplot2)
library(grid)
library(gridExtra)
library(lubridate)

# installing the prophet library
install.packages("prophet")
library(prophet)

#reading the csv file
setwd("~/Library/CloudStorage/OneDrive-GeorgeMasonUniversity-O365Production/Fall 2022/AIT-580/Assignments/Project")

df <- read.csv("RealEstateFinalClean.csv")

#confirming no null values in the csv file
sum(is.na(df))

str(df)

#converting date recorded as date datatype
df$Date.Recorded <- as.Date(df$Date.Recorded)
str(df)

########################################################################################

#SalesRatioRank(Average) vs List.Year

dfNewSRY <- df %>% group_by(List.Year) %>% 
  summarise(meanSalesRatio=mean(Sales.Ratio),
            .groups = 'drop')
summary(dfNewSRY$meanSalesRatio)

cat <- c("Rank 5", "Rank 4","Rank 3", "Rank 2", "Rank 1")
intervals <- c(0,0.6,0.7,0.8,0.9,10)
dfNewSRY$SaleRatioRank<-NA
dfNewSRY$SaleRatioRank <- cut(dfNewSRY$meanSalesRatio,breaks = intervals,labels = cat)
dfNewSRY$List.Year = as.factor(dfNewSRY$List.Year)
o <- ggplot(dfNewSRY, aes(x = List.Year , y = SaleRatioRank))+ 
  geom_point(aes(color = SaleRatioRank)) + ggtitle("Sales Ratio Rank for each Year \n (Average in consideration)")
o + theme( plot.title = element_text(hjust = 0.5)  )

################################################################
#SalesRatioRank(Max) vs List.Year

dfNewSRY1 <- df %>% group_by(List.Year) %>% 
  summarise(maxSalesRatio=max(Sales.Ratio),
            .groups = 'drop')
summary(dfNewSRY1$maxSalesRatio)

intervals2 <- c(10,35,80,110,200,1000)
dfNewSRY1$SaleRatioRank <- NA
dfNewSRY1$SaleRatioRank <- cut(dfNewSRY1$maxSalesRatio,breaks = intervals2,labels = cat)
dfNewSRY1$List.Year = as.factor(dfNewSRY1$List.Year)
p<- ggplot(dfNewSRY1, aes(x =List.Year , y = SaleRatioRank))+ 
  geom_point(aes(color = SaleRatioRank)) +ggtitle("Sales Ratio Rank for each Year \n (Max in consideration)")
p+ theme( plot.title = element_text(hjust = 0.5)  )
  #ggtitle("Sales Ratio Rank for each Year \n (Max in consideration)")

########################################################################################

#splitting dataframe to analyse the sales amount, assessed value, sales ratio
df1 <- df[,c("Date.Recorded","Assessed.Value")]
df2 <- df[,c("Date.Recorded","Sale.Amount")]
df3 <- df[,c("Date.Recorded","Sales.Ratio")]

########################################################################################

# mean assessed value
df1Ren <- df1 %>% group_by(Date.Recorded) %>% 
  summarise(mean_assessedvalue=mean(Assessed.Value),
            .groups = 'drop')

#renaming the columns for prophet library
df1Ren <- mutate (
  df1Ren,
  ds = Date.Recorded,  
  y = mean_assessedvalue  
)
df1Ren <- column_to_rownames(df1Ren, var = "Date.Recorded")

#Predecting future values using prophet values
m <- prophet(df1Ren)
predFuture <- make_future_dataframe(m, periods = 365)
forecastFuture <- predict(m, predFuture)

plot(m, forecastFuture,xlabel = "Months", ylabel = "Assessed Value") + labs(title="Assessed Value throughout the Years")

prophet_plot_components(m, forecastFuture)

########################################################################################

# mean sales amount
df2Ren <- df2 %>% group_by(Date.Recorded) %>% 
  summarise(mean_saleamount=mean(Sale.Amount),
            .groups = 'drop')
#renaming the columns for prophet library
str(df2Ren)
df2Ren <- mutate (
  df2Ren,
  ds = Date.Recorded,  
  y = mean_saleamount  
)
df2Ren <- column_to_rownames(df2Ren, var = "Date.Recorded")

#Predecting future values using prophet values
m2 <- prophet(df2Ren)
predFuture2 <- make_future_dataframe(m2, periods = 365)
forecastFuture2 <- predict(m2, predFuture2)

plot(m2, forecastFuture2,xlabel = "Months", ylabel = "Sale Amount") + labs(title="Sale Amount throughout the Years")

prophet_plot_components(m2, forecastFuture2)

########################################################################################

# mean sales ratio
df3Ren <- df3 %>% group_by(Date.Recorded) %>% 
  summarise(mean_salesratio=mean(Sales.Ratio),
            .groups = 'drop')

#renaming the columns for prophet library
str(df3Ren)
df3Ren <- mutate (
  df3Ren,
  ds = Date.Recorded,  
  y = mean_salesratio  
)
df3Ren <- column_to_rownames(df3Ren, var = "Date.Recorded")

#Predecting future values using prophet values
m3 <- prophet(df3Ren)
predFuture3 <- make_future_dataframe(m3, periods = 365)
forecastFuture3 <- predict(m3, predFuture3)

plot(m3, forecastFuture3,xlabel = "Months", ylabel = "Sale Ratio") + labs(title="Sale Ratio throughout the Years")

prophet_plot_components(m3, forecastFuture3)

