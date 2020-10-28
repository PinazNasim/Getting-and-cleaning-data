# Getting-and-cleaning-data
library(data.table)
library(dplyr)
library(tidyselect)
library(tidyr)
setwd("C://Users//DELL//Documents//UCI HAR Dataset")

#1 Merging the training and the test sets to create one data set
# reading the train related data files and assigning it to appropriate names

Train_x_features<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//X_train.txt", header = FALSE)
Train_y_activity<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//y_train.txt", header = FALSE)
Train_subject<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//subject_train.txt",
                           header = FALSE)
# reading the test related data files and assigning it to appropriate names

Test_x_features<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//X_test.txt")
Test_y_activity<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//y_test.txt")
Test_subject<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//subject_test.txt")
Test_Data<- cbind(Test_x_features, Test_y_activity, Test_subject)
 
#3 Uses descriptive activity names to name the activities in the data set
#reading the features related data files and assigning it to appropriate name
dataFeaturesNames<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//features.txt", header = FALSE)

# combining data 

dataSubject<- rbind(Train_subject, Test_subject)
dataFeatures<- rbind(Train_x_features, Test_x_features)
dataActivity<- rbind(Train_y_activity, Test_y_activity)

# assigning the names of the column in the combined data
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures)<- dataFeaturesNames$V2

#combining data to achieve the final data required

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#2
# Extracting only the measurements on the mean and standard deviation for each measurement

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
activityLabels <- read.table("C://Users//DELL//Documents//UCI HAR Dataset//activity_labels.txt",
                      header = FALSE)
#4 Appropriately labeling the data set with descriptive variable names

head(Data$activity,30)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

#5 From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
Data2<- aggregate(. ~subject + activity, Data, mean)
Data2<- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
