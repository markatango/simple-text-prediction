library(aws.s3)
library(aws.ec2metadata)
library(aws.signature)

# Set up data directories
dataDir <- "data2"

dirOrigName <- paste0('./',dataDir,'/final/en_US')
dirCleanName <-paste0('./',dataDir,'/final/en_US_clean')
dirSampName <- paste0('./',dataDir,'/final/en_US_sample')
dirTempName <- paste0('./',dataDir,'/final/en_US_temp')

subDirs = c(dirOrigName,
            dirCleanName,
            dirSampName,
            dirTempName
            )

dirExists <- dir.exists(dataDir)

if(!dirExists){
  for (sd in subDirs){
    system2("mkdir",args=c("-p",sd),
            input = NULL,
            wait = TRUE
    )
  }
} 

# confirm the file structure is there
structureIsPresent <- c()
for (d in subDirs){
  print(paste(d,dir.exists(d)))
  structureIsPresent <- append(structureIsPresent,dir.exists(d))
}

fileStuctureExists <- all(structureIsPresent)

if(fileStuctureExists){
  print("FileStructure is present")
}


s3bucket <- "langmodeldata"
dataset <- get_bucket(s3bucket)

# find files with desired language
langFile <- "en_US"
keys <- c()
for (i in seq(length(dataset))){
  keys <- append(keys,dataset[[i]]$Key)
}
docNames <- keys[grepl(langFile, keys)]

writeS3ToTextFile <- function(file){
  cat(s3read_using(FUN=readLines, object=file, bucket=s3bucket), file="./data25.txt")
}

writeS3ToTextFile(keys[1])

