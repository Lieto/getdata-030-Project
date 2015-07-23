# getdata-030-Project
Project work for Coursera Getting and Cleaning Data course

Script: run_analysis.R

Script will first create data-subdirectory if not already created and downloads dataset if not
already in data subdirectory. Next datafile is unzipped.

Activity and feature labels are loaded from files activity_labels.txt and features.txt

Assumption is made that we are dealing only with features, which have both mean and std-
measurements, so we find feature labels, which have substring mean() or std()

Test and train datasets are combined on those features, in addition subject id and activity id
data are merged as first and last column

Activity numbers are changed to strings in merged dataset based on activity labels

Column headers are added to combined dataset

To tidy data we use dply-library to calculate averages for mean and std variables for each
subject and each activity. This is so called wide format, because we are not collapsing
66 variables into rows. 

Finally tidied data is written to text file

