# set working directory
setwd("C:/Users/liezl/Documents/DataScienceCourse/Getting and Cleaning Data/DS3_GaCD_project")


#a. Install required R packages

  #install.packages('reshape2')


# b. Load required R packages

  require(reshape2)

# c. Download data into working directory and unzip

  # if subfolder "/data" does not exist, create it.
  if(!file.exists("./data")){
    dir.create("./data")
  }

  # download the zip file into the data folder
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if(!file.exists("./data/UCIdata.zip")){
    download.file(url, destfile = "./data/UCIdata.zip")
  }

  # unzip data file
  unzip("./data/UCIdata.zip",exdir = "./data" )
  
# d. Read tables into R

  # load activity_labels dataframe with 6 obs. of  2 variables
  act_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
  str(act_labels)
  head(act_labels)
  
  # load features dataframe with 561 obs. of  2 variables
  feat <- read.table("./data/UCI HAR Dataset/features.txt")
  str(feat)
  head(feat)
  
  # load X_train dataframe with 7352 obs. of  561 variables (takes very long)
  xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
  str(xtrain)
  head(xtrain)
  
  # load y_train dataframe with 7352 obs. of  1 variable
  ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
  str(ytrain )
  head(ytrain )
  table(ytrain)

  # load X_test dataframe with 2947 obs. of  561 variables
  xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
  str(xtest)
  head(xtest)
  
  # load y_test dataframe with 2947 obs. of  1 variable
  ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
  str(ytest)
  head(ytest)
  table(ytest)


# 1. Merging the data sets
  
  # merge training data and rename first column to "act_id" 
  train <- cbind(ytrain,xtrain)
  colnames(train)[1] <- c("act_id")
  
  # merge test data and rename first column to "act_id"
  test <- cbind(ytest,xtest)
  colnames(test)[1] <- c("act_id")
  
  # merges the training and the test sets to create one data set 
  # with 10299 obs. of  562 variables
  big_df <- rbind(train,test)
  str(big_df)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  
  # look at features
  feat

  # search for features with name "mean()"
  meanloc <- grepl("mean()", feat$V2, fixed = TRUE)
  meanvars <- feat$V1[meanloc == TRUE]

  # search for features with name "std()"
  stdloc <- grepl("std()", feat$V2, fixed = TRUE)
  stdvars <- feat$V1[stdloc == TRUE]

