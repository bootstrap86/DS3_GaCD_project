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

  # load training subjects names into dataframe with 561 obs. of  2 variables
  subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
  str(subject_train)
  table(subject_train)

  # load test subjects names into dataframe with 561 obs. of  2 variables
  subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
  str(subject_test)
  table(subject_test)
    
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
  train <- cbind(subject_train,ytrain,xtrain)
  str(train)
  colnames(train)[2] <- c("act_id")
  
  # merge test data and rename first column to "act_id"
  test <- cbind(subject_test,ytest,xtest)
  colnames(test)[2] <- c("act_id")
  
  # merges the training and the test sets to create one data set 
  # with 10299 obs. of  562 variables
  big_df <- rbind(train,test)
  colnames(big_df)[1] <- "subject_id"  
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

  # subsetting big data set to get only the measurements on 
  # the  mean and standard deviation for each measurement
  # result: dataframe with 10299 obs. of  68 variables
  msvars <- sort(cbind(meanvars,stdvars))
  ms_df <- big_df[,c(1,2,2+msvars)]  #extracted measurements of the means and stdevs of the measurements
  str(ms_df)   


# 3. Uses descriptive activity names to name the activities in the data set
  
  # look at activity labels and rename first column to "act_id"
  act_labels
  colnames(act_labels)[1] <- "act_id"
  
  # merging the activity labels with the data set variables on "act_id"
  total <- merge(act_labels,ms_df,by="act_id")
  str(total)
  
  # rename columns
  colnames(total)[2] <- "act_name"
  colnames(total)[5] <- "V2"
  str(total)
  head(total)


# 4. Appropriately labels the data set with descriptive variable names

  colnames(total)[4:69] <- as.character(feat$V2[msvars])
  colnames(total)

  
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

  library(reshape2)
  meltdata <- melt(total, id.vars = c("act_name", "subject_id"))
  tidydata <- dcast(meltdata, act_name + subject_id ~ variable, mean)
  head(tidydata)
  
  write.table(tidydata, "./mytidydata.txt", sep="\t", row.name=FALSE)
