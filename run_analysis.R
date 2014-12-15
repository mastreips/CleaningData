## Getting and Cleaning Data Course Project
#  Author: Marcus A. Streips
#  Date: December 15, 2014
#
# Please set your working directory to the folder containing the data
#
# This script uses the dplyr and tidyr packages to reorganize, merge, filter
# and sort the UCI HAR data set in order to present tidy data set with the average
# of each mean() and std() variable for each activity and each subject pair. 
#
# The study consists of 30 subjects each with 6 activities being monitored and 
# assigned to one of two groups (test and train).
#
# The data was loaded into R objects for each group (test and train) and converted
# to tidy tables.  The variables were renamed to allow for easy filtering and 
# transformed from rows to columns prior to merging with the data set.   
# 
# Once merged, the data is filtered to conprise only of mean() and std() data. The
# arrange function is then used to apply a mean of the observations for each subject
# and activity pair.  The resulting dataset is sotred in a tidy table text file. 

library(dplyr)
library(tidyr)

#Set working directory as appropriate
setwd("D:/Users/mstreips/Google Drive/Coursera/Getting and Cleaning Data/Project")

########################
##collect training data#
########################
path2train<-"./UCI HAR Dataset/train/"
features_data<-read.csv("./UCI HAR Dataset/features.txt", sep="", 
                        stringsAsFactors = FALSE, header=FALSE)
xtrain_data<-read.csv(paste(path2train,"X_train.txt", sep=""), sep="", 
                      stringsAsFactors = FALSE, header=FALSE)
ytrain_data<-read.csv(paste(path2train,"y_train.txt", sep=""), sep="", 
                      stringsAsFactors = FALSE, header=FALSE)
subject_train_data<-read.csv(paste(path2train,"subject_train.txt", sep=""), sep="", 
                      stringsAsFactors = FALSE, header=FALSE)

#convert to tidy tables
tbl_features<-tbl_df(features_data)
tbl_xtrain<-tbl_df(xtrain_data)
tbl_ytrain<-tbl_df(ytrain_data)
tbl_subject_train<-tbl_df(subject_train_data)

#Rename variables
names(tbl_ytrain)[1] <- "Activity"
names(tbl_subject_train)[1] <- "Subject"

#combine tables
temp1<-cbind(tbl_subject_train, tbl_ytrain)
temp2 <- t(tbl_features) #transform
temp2 <- temp2[2,]

names(tbl_xtrain)<-make.names(temp2, unique=TRUE) #rename variables 

temp3 <- cbind(temp1, tbl_xtrain)

####################
##collect test data#
####################
path2test<-"./UCI HAR Dataset/test/"
xtest_data<-read.csv(paste(path2test,"X_test.txt", sep=""), sep="", 
                      stringsAsFactors = FALSE, header=FALSE)
ytest_data<-read.csv(paste(path2test,"y_test.txt", sep=""), sep="", 
                      stringsAsFactors = FALSE, header=FALSE)
subject_test_data<-read.csv(paste(path2test,"subject_test.txt", sep=""), sep="", 
                             stringsAsFactors = FALSE, header=FALSE)
#convert to tidy tables
tbl_xtest<-tbl_df(xtest_data)
tbl_ytest<-tbl_df(ytest_data)
tbl_subject_test<-tbl_df(subject_test_data)

#rename variables
names(tbl_ytest)[1] <- "Activity"
names(tbl_subject_test)[1] <- "Subject"

temp1<-cbind(tbl_subject_test, tbl_ytest)
temp2 <- t(tbl_features) ##transpose rows to column. 
temp2 <- temp2[2,]

names(tbl_xtest)<-make.names(temp2, unique=TRUE) #rename variables

temp4 <- cbind(temp1, tbl_xtest)

##merge test and training data into one table

data <- rbind(temp3, temp4)
tbl_data <- tbl_df(data)

#select mean and std data from all observations
final_data <- tbl_data %>% select(Subject, Activity, contains('mean'),contains('std'))

#Label Activities
final_data$Activity <- factor(final_data$Activity, levels = c(1,2,3,4,5,6),
                              labels = c("WALKING", "WALKING_UPSTAIRS", 
                                         "WALKING_DOWNSTAIRS", "SITTING", 
                                         "STANDING", "LAYING"))

#average of each variable for each activity/subject pair. 
avg2<- aggregate(. ~ Subject + Activity, data=final_data, FUN="mean")

#sort data by subject and then by activity
avg_final<- avg2 %>% arrange(Subject, Activity)

#write output to tidy table
write.table(avg_final, file="tidy_data.txt", row.name=FALSE)

# INSTRUCTIONS FOR LOADING tidy data table
# data_table <- read.table("tidy_data.txt", header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
# View(data_table)