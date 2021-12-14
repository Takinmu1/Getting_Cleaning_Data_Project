library(dplyr)

# Checking if archieve already exists
fileused<- "Coursera_GCD_Project.zip"
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, fileused)

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(fileused) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
xtable <- rbind(x_train, x_test)
ytable <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, ytable, xtable)

NewData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

NewData$code <- activities[NewData$code, 2]

names(NewData)[2] = "activity"
names(NewData)<-gsub("Acc", "Accelerometer", names(NewData))
names(NewData)<-gsub("Gyro", "Gyroscope", names(NewData))
names(NewData)<-gsub("BodyBody", "Body", names(NewData))
names(NewData)<-gsub("Mag", "Magnitude", names(NewData))
names(NewData)<-gsub("^t", "Time", names(NewData))
names(NewData)<-gsub("^f", "Frequency", names(NewData))
names(NewData)<-gsub("tBody", "TimeBody", names(NewData))
names(NewData)<-gsub("-mean()", "Mean", names(NewData), ignore.case = TRUE)
names(NewData)<-gsub("-std()", "STD", names(NewData), ignore.case = TRUE)
names(NewData)<-gsub("-freq()", "Frequency", names(NewData), ignore.case = TRUE)
names(NewData)<-gsub("angle", "Angle", names(NewData))
names(NewData)<-gsub("gravity", "Gravity", names(NewData))

FinalData <- NewData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)

FinalData

