CleaningData
============

Class Project Repository for Getting and Cleaning Data Course

# INSTRUCTIONS FOR LOADING tidy data table
 data_table <- read.table("tidy_data.txt", header = TRUE)
 
 View(data_table)

# Getting and Cleaning Data Course Project

Author: Marcus A. Streips
Date: December 15, 2014

Please set your working directory to the folder containing the data

This script uses the dplyr and tidyr packages to reorganize, merge, filter
and sort the UCI HAR data set in order to present tidy data set with the average
of each mean() and std() variable for each activity and each subject pair. 

The study consists of 30 subjects each with 6 activities being monitored and 
assigned to one of two groups (test and train).

The data was loaded into R objects for each group (test and train) and converted
to tidy tables.  The variables were renamed to allow for easy filtering and 
transformed from rows to columns prior to merging with the data set.   
 
Once merged, the data is filtered to conprise only of mean() and std() data. The
arrange function is then used to apply a mean of the observations for each subject
and activity pair.  The resulting dataset is sotred in a tidy table text file.
