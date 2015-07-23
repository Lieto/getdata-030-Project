library(dplyr)

ProcessVariableName <-function(originalName) {
  
  name = as.character(originalName)
  # Take first character and create "Time" of "Frequency" string
  first = substring(name, 1, 1)
  rest = substring(name, 2, nchar(name))
  if (first == "t") {
    first = "Time"
  }
  else {
    first = "Frequency"
  }
  
  # Split rest on "-" chars to three strings
  strings = strsplit(rest, split = "-", fixed = TRUE)
  # Change mean() to Mean and std() to Std
  if (strings[[1]][2] == "mean()") {
    strings[[1]][2] = "Mean"
  }
  else if (strings[[1]][2] == "std()") {
    strings[[1]][2] = "Std"
  }
  
  # Change order
  returnString = paste(first, strings[[1]][1], strings[[1]][3] , strings[[1]][2], sep = " ")
  return(returnString)

}

# Check if we have data directory, create if not
if (!file.exists("data")) {
  dir.create("data")
}

# Download dataset if not laready loaded
if (!file.exists("./data/dataset.zip")) {
  
  fileUrlCsv = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrlCsv, destfile="./data/dataset.zip")
}

# Unzip dataset
unzip("./data/dataset.zip", exdir = "./data")

# Read activity labels from file
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Read feature labels from file
features = read.table("./data/UCI HAR Dataset/features.txt")

# Find features with mean and sd
meanIndexes = features[(grep("mean()", features$V2, fixed=TRUE)), ]
stdIndexes = features[(grep("std()", features$V2, fixed=TRUE)), ]
indexes = rbind(meanIndexes, stdIndexes)
#indexes = indexes[sort(indexes$V1), ]
indexes = indexes[with(indexes, order(indexes$V1)), ]
#i = sort(indexes$V1)


# 1 Merge the training and the test sets to create one data set

# Read test and train sets (X and y and subject files)
test.X = read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y = read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
train.X = read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y = read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject = read.table("./data/UCI HAR Dataset/train/subject_train.txt")

data.subject = rbind(test.subject, train.subject)
names(data.subject) = c("Subject")
data.X = rbind(test.X, train.X)
names(data.X) = features$V2
data.y = rbind(test.y, train.y)
names(data.y) = c("Activity")
# Change the activity numbers to activity names
data.y = apply(data.y, 1, function(x) as.character(activityLabels$V2[x] ))

# Extract mean and std features from X
data.X = data.X[ , unlist(indexes$V1)]

# Combine subject, features and activities into a single data frame
dataset = data.frame(data.subject, data.X, data.y)
# Define names for columns
data.labels = c("SubjectId")

#features_tmp = apply(indexes$V2, fun = ProcessVariableName)
data.labels = c(data.labels, as.character(indexes$V2))
data.labels = c(data.labels, "Activity")

#data.labels = c("SubjectId", "Mean", "Std", "Activity")

names(dataset) = data.labels

# 5
library(plyr)
library(dplyr)

dataset = tbl_df(dataset)

tidy_data = ddply(dataset, .(SubjectId, Activity), colwise(mean))

write.table(x = tidy_data, file = "./data/tidy_data.txt", row.names = FALSE)


