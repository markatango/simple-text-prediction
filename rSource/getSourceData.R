
# Davies, Mark. (2011) N-grams data from the Corpus of Contemporary American English (COCA). Downloaded from http://www.ngrams.info on April 7, 2015. 




for (sub_dir in list(dirOrigName, dirCleanName, dirSampName, dirTempName)){
  if (!file.exists(sub_dir)) dir.create(file.path("./", sub_dir))
}

readAndLower <- function(f,dirName){
  t <- readLines(paste0(dirName,"/",f,collapse=" "),skipNul=TRUE,encoding='latin1')
  t <- iconv(t,from="latin1",to="ASCII",sub="")
  tolower(t)
}

removeFiles <- function(dirName){
  dirName <- gsub("\\\\","/",dirName)
  system(paste0("rm ",dirName,"/*.*",collapse=""))
}

writeSamples <- function(x,dirName){
  n <- length(x)
  for (i in 1:n){
    outFile <- gsub(".txt","",fileList[i])
    outFile <- gsub("_sample_\\d\\.?\\d*","",outFile)
    outFile <- paste0(outFile,"_sample_",SAMPLESIZE,".txt")
    writeLines(x[[i]],paste0(dirName,"/",outFile))
  }
}

#==========================  START ================================

stopExists <- stopExistsMod("getSourceData.R")

# Get the lower case full data initially, clean, one line per sentence
if (STARTUP & !READDATA){
  fileNames <- system(paste("dir ", dirOrigName),intern=TRUE)
  fileList <- strsplit(fileNames, "\\s+")[[1]]
  
  texts <- lapply(fileList, readAndLower, dirOrigName)
  nTexts <- sapply(texts,length)
  if (SAMPLESIZE < 1.0){
      set.seed(1340)
      texts <- lapply(1:length(texts),function(i){
        texts[[i]][sample(1:nTexts[i], SAMPLESIZE * nTexts[i])]
      })
  }

  # delay cleaning until sample is selected (cleaning is slow)
  texts <- lapply(texts,cleanText)
  
  if (file.exists(dirCleanName)) {
    print(paste(dirCleanName, "exists.  Removing..."))
    unlink(dirCleanName, recursive = TRUE)
    print(paste(dirCleanName, "Removed"))
  } else {
    print(paste(dirCleanName, "does not exist. Creating new directory..."))
    system( paste("mkdir","-p", dirCleanName), intern=TRUE)
  }
  
  writeSamples(texts,dirCleanName)
}

if (STARTUP & READDATA){
  # If clean data is already present just read in here to sample
  if (file.exists(dirCleanName)) {
    fileNames <- system(paste("dir ", dirCleanName),intern=TRUE)
    fileList <- strsplit(fileNames, "\\s+")[[1]]
    fullFileNames <- paste(dirCleanName,"/",fileList,sep="")
    
    texts <- lapply(fullFileNames, readLines)
  } else {
    print(paste(dirCleanName, "does not exist."))
    print("Go back and set params to read dataset and create clean data")
  }
}

stopExists("texts")
stopExists("fileList")
stopExists("fullFileNames")

nTexts <- sapply(texts,function(t)length(t))
nDocs <- length(nTexts)


save.image()


