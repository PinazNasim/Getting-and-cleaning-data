library(data.table)
library(dplyr)
library(tidyselect)
library(tidyr)
setwd("C://Users//DELL//Documents//UCI HAR Dataset")

#1
Train_x_features<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//X_train.txt", header = FALSE)
Train_y_activity<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//y_train.txt", header = FALSE)
Train_subject<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//train//subject_train.txt",
                           header = FALSE)

Test_x_features<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//X_test.txt")
Test_y_activity<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//y_test.txt")
Test_subject<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//test//subject_test.txt")
Test_Data<- cbind(Test_x_features, Test_y_activity, Test_subject)
 
#3
dataFeaturesNames<- read.table("C://Users//DELL//Documents//UCI HAR Dataset//features.txt", header = FALSE)

dataSubject<- rbind(Train_subject, Test_subject)
dataFeatures<- rbind(Train_x_features, Test_x_features)
dataActivity<- rbind(Train_y_activity, Test_y_activity)
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures)<- dataFeaturesNames$V2


dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#2
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
activityLabels <- read.table("C://Users//DELL//Documents//UCI HAR Dataset//activity_labels.txt",
                      header = FALSE)
#4
head(Data$activity,30)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

#5
library(plyr)
Data2<- aggregate(. ~subject + activity, Data, mean)
Data2<- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
