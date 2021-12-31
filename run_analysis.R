library(dplyr)

# Checking if archive already exists
filename<- "Coursera_GCD_Project.zip"
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, filename)

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(fileused) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
xtable <- rbind(x_train, x_test)
ytable <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Mergedfiles <- cbind(Subject, ytable, xtable)

combineddata <- Mergedfiles %>% select(subject, code, contains("mean"), contains("std"))

combineddata$code <- activities[combineddata$code, 2]

names(combineddata)[2] = "activity"
names(combineddata)<-gsub("Acc", "Accelerometer", names(combineddata))
names(combineddata)<-gsub("angle", "Angle", names(combineddata))
names(combineddata)<-gsub("BodyBody", "Body", names(combineddata))
names(combineddata)<-gsub("^f", "Frequency", names(combineddata))
names(combineddata)<-gsub("-freq()", "Frequency", names(combineddata), ignore.case = TRUE)
names(combineddata)<-gsub("gravity", "Gravity", names(combineddata))
names(combineddata)<-gsub("Gyro", "Gyroscope", names(combineddata))
names(combineddata)<-gsub("Mag", "Magnitude", names(combineddata))
names(combineddata)<-gsub("-mean()", "Mean", names(combineddata), ignore.case = TRUE)
names(combineddata)<-gsub("-std()", "STD", names(combineddata), ignore.case = TRUE)
names(combineddata)<-gsub("^t", "Time", names(combineddata))
names(combineddata)<-gsub("tBody", "TimeBody", names(combineddata))



FinalData <- combineddata %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)

FinalData
