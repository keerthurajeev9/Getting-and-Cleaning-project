
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("no","func"))
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Sub")
SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Sub")
Activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("val", "activity"))
Test_X <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$func)
Test_Y<- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "val")
Train_Y <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "val")
Train_X <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$func)



XFin <- rbind(Train_X, Test_X)
YFin <- rbind(Train_Y , Test_Y)
SubjectFin <- rbind(SubjectTrain, SubjectTest)
Combine <- cbind(SubjectFin, YFin, XFin)
TData <-Combine %>% select(Sub, val, contains("mean"), contains("std"))
TData$val <- Activity[TData$val, 2]

names(TData)[2] = "act"

TidyDataFinal <- TData %>%
  group_by(Sub, act) %>%
  summarise_all(funs(mean))
write.table(TidyDataFinal, "TidyDataFinal.txt", row.name=FALSE)
str(TidyDataFinal)
TidyDataFinal
