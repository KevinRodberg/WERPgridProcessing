path = '//ad.sfwmd.gov/dfsroot/data/wsd/PLN/Felipe/WERP_Rd2_MapsData/Ponding'
pathName = paste0(path, '/*.txt')
filename <- choose.files(default = pathName)
parsename <- unlist(strsplit(filename,"[\\\\]|[^[:print:]]"))
setname <- unlist(strsplit(parsename[length(parsename)],'_'))[1]
cat(paste(setname,'\n'))
fullDF <- read.csv(filename, row.names = NULL, header = TRUE)
fullDF$X <- NULL

keepDF <- subset(fullDF,select=c("CellId","X1989","X1995","X2003","X1965.2005"))
names(keepDF)[names(keepDF)=="X1965.2005"]<-"POR_AVG"
names(keepDF)<-c("CellId",unlist(lapply(names(keepDF)[-1],function(x) paste0(setname,x))))

for (i in seq(1, 4)) {
  filename <- choose.files(default = pathName)
  parsename <- unlist(strsplit(filename,"[\\\\]|[^[:print:]]"))
  setname <- unlist(strsplit(parsename[length(parsename)],'_'))[1]
  cat(paste(setname,'\n'))
  
  fullDF <- read.csv(filename, row.names = NULL, header = TRUE)
  fullDF$X <- NULL
  
  subDF <- subset(fullDF,select=c("CellId","X1989","X1995","X2003","X1965.2005"))
  names(subDF)[names(subDF)=="X1965.2005"]<-"POR_AVG"
  names(subDF)<-c("CellId",unlist(lapply(names(subDF)[-1],function(x) paste0(setname,x))))
  keepDF <-merge(x = keepDF, y = subDF, by = "CellId", all = TRUE)
}
output <- paste0(path,'/subset.csv')
write.csv(keepDF,output)
