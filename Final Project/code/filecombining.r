# This file will merge all the basic datasets into one big dataset.
# run this file first before running the py file.

library(readr)
library(dplyr)

#myfiles = lapply(temp, read.delim)

temp = list.files(path = "E:/data/2018 US weekly", pattern="*.csv")
#ytbl = lapply(temp, read_csv) %>% bind_rows()
total = data.frame()

for(i in c(1:length(temp))){
  ytbl <-read.csv(paste("E:/data/2018 US weekly/",temp[i], sep = ""), skip=1)
  ytbl <- cbind(ytbl, Date = substring(temp[i], 20, 29))
  #ytbl <- lapply(ytbl, cbind, Date = substring(temp[i], 20, 29))
  total <- rbind(total, ytbl)
  
}
write.csv(total, file = "E:/data/data/MyData1.csv",row.names=FALSE)
