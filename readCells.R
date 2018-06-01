library(stringr)
path = '//ad.sfwmd.gov/dfsroot/data/wsd/PLN/Felipe/WERP_Rd2_MapsData/Ponding'
pathName = paste0(path,'/*.txt')
filename<-choose.files(default=pathName)
output<- paste0(filename,'.csv')
#filename = 'WALT3RNL_Rd2_pond_YrAvg.txt'
#filePath = paste(pathName,filename,sep="/")
#readCells <- function(filename) {
  line =NULL
  to.read = file(filename, "r")
  while(length(line <- readLines(to.read,n=1) )>0){
    cat(paste(line,'\n'))
    if(line == 1965) {
      year= line
      line <- readLines(to.read,n=1)
      cellCount = as.numeric(as.character(line))
      break
    }
  }
  cat(paste(year,'\n'))
  cat(paste(cellCount,'\n'))
  
  lines = readLines(to.read,n=cellCount)
  df <-as.data.frame(str_split_fixed(lines[1:cellCount],"," ,n=2))
  df$V1 <-as.numeric(as.character(df$V1))
  df$V2 <-as.numeric(as.character(df$V2))
  names(df)<- c('CellId',as.character(year))
  
  while (nchar(year)<6){
    line <- readLines(to.read,n=1)
    year = as.character(line)
    
    line <- readLines(to.read,n=1)
    cellCount = as.numeric(as.character(line))
    
    cat(paste(year,'\n'))
    cat(paste(cellCount,'\n'))
    
    lines = readLines(to.read,n=cellCount)
    
    nextdf <-as.data.frame(str_split_fixed(lines[1:cellCount],"," ,n=2))
    nextdf$V1 <-as.numeric(as.character(nextdf$V1))
    nextdf$V2 <-as.numeric(as.character(nextdf$V2))
    names(nextdf)<- c('CellId',as.character(year))
    df <-merge(x = df, y = nextdf, by = "CellId", all = TRUE)
  }
  close(to.read)
  write.csv(df,output)
#  return(MFmodel.Params)
#}