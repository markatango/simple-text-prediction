library(tm)
library(reshape2)
library(ggplot2)
library(slam)
library(pryr)
library(pracma)
library(stringi)
library(foreach)
library(iterators)
library(shiny)
library(plyr)
library(caret)
library(yaml)

config <- read_yaml("config.yml", fileEncoding = "UTF-8", text, error.label="Read config.yml error", readLines.warn=TRUE)

directories <- config[["directories"]]
switches <- config[["switches"]]
params <- config[["params"]]

#  Modes:
#  Read in the full dataset and clean it: STARTUP and !READDATA
#  Build ngrams and probability table from full dataset in memory
#  Build ngrams and probability table from sampled dataset in memory !STARTUP and !READDATA and SAMPLEDATA and MAKENGRAMS
#  Build
#


ONSURFACE <- FALSE
DEBUGMODE <- FALSE
STARTUP <- FALSE          # get data, either from the clean data dir or from the original texts per READDATA flag
READDATA <- TRUE          # TRUE: data is already in environment; FALSE: read original data
SAMPLEDATA <- FALSE    # Create a subset of the data that has been made available
MAKENGRAMS <- FALSE        # Generate the n-grams and source additional functions used by the server
RPTLEN <- 5
GRAPHLEN <- 10            # number of candidate 'next word' to display in the probability bargraph
NMAX <- 4                 # depth of ngram search
FILTERTHRESHOLD <- 1      # terms that appear less times than this value are not included
TESTSUBSAMPLESIZE <- 1000

echoRDir <- function(dir){
  function(rfile) {
    fName <- paste0(dir,"/",rfile)
    source(fName, echo=TRUE) 
  }
}

stopExistsMod <- function(ch.rModule) {
  function(ch.obj) if (!exists(ch.obj)) stop(paste0(ch.rModule,": '",ch.obj,"' ","does not exist"))
}
  
echoSource <- echoRDir("rSource")

#==========================  START ================================

set.seed(1340)

# echoSource("helpers.R")
echoSource("cleanText.R")

## set sample size for initial data input
# create full, clean data files in the clean data directory
if(STARTUP){
  SAMPLESIZE <- 1
  echoSource("getSourceData.R")
  STARTUP <- FALSE
}

# create a subset of clean data from "texts" which must be in memory
if(SAMPLEDATA){
  SAMPLESIZE <- 0.2
  echoSource("sampleSourceData.R")
  SAMPLEDATA <- FALSE
}

# clean the texts
# if(CLEANDATA){
#   echoSource("cleanData.R")
# }

# build the ngram frequency table using the cleaned data

if(MAKENGRAMS){
  echoSource("makeNgrams.R")
  MAKENGRAMS <- FALSE
}

echoSource("getCandidates.R")
echoSource("predict.R")



