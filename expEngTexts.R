# exploring the data

library(sqldf)
library(tm)
library(RWeka)

moneyTest <- c("$1.00 ","alpha","$25,004,005,909.25 ","$ 25,250 ","$  ,20 ","$2500,2500 ","$25.23.23.23 ","$25.203 ")
moneyUSD <- "\\$\\s{0,1}([[:digit:]]{1,3})(\\s+|(\\.[[:digit:]]{2}\\s)|(((,[[:digit:]]{3},)*)(,[[:digit:]]{3})+(\\s|\\.[[:digit:]]{2}\\s)))"
grep(moneyUSD,moneyTest,fixed=FALSE)

NEW <- TRUE

if(NEW){
  enDir <- 'data/final/en_US'
  enCorp <- VCorpus(DirSource(enDir,encoding="utf-8",mode="text"))
  badWords <- readLines("badWords.txt")
  enCorp.1 <- tm_map(enCorp,removeWords,badWords)
  save(enCorp.1, 'wsOrig.RData')
  rm(enCorp)
  gc()
  
} else {
  load('wsOrig.RData')
}

## use test corpus crude in tm
library(tm)
data(crude)

#random training sample
half<-floor(length(crude)/2)
train<-sample(1:length(crude), half)

# meta doesnt handle lists or vector very well, so loop:
for (i in 1:length(crude)) meta(crude[[i]], tag="Tset") <- "test"
for (i in 1:half) meta(crude[[train[i]]], tag="Tset") <- "train"

# check result
for (i in 1:10) print(meta(crude[[i]], tag="Tset"))
