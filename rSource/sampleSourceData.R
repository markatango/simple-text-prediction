stopExists <- stopExistsMod("sampleSourceData.R")
stopExists("texts")

if (SAMPLEDATA){
  set.seed(1340)
  sampTexts <- lapply(1:length(texts),function(i){
    texts[[i]][sample(1:nTexts[i], SAMPLESIZE * nTexts[i])]
  })
  
  if (file.exists(dirSampName)) {
    print(paste(dirSampName, "exists.  Removing..."))
    unlink(dirSampName, recursive = TRUE)
    print(paste(dirSampName, "Removed"))
  } else {
    print(paste(dirSampName, "does not exist. Creating new directory..."))
    system( paste("mkdir","-p", dirSampName), intern=TRUE)
  }
  
  writeSamples(sampTexts,dirSampName)
  
  rm(texts,sampTexts)
  
  gc()
  
  dCorpus <- Corpus(DirSource(dirSampName))
  nDocs <- length(dCorpus)
  nTexts <- sapply(lapply(dCorpus,content),length)
  save.image()
}