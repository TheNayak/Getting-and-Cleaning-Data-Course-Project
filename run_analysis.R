#####Step1: Merges the training and the test sets to create one data set.
## The traininig and test sets are to be read and stored in variables calles [X_test,Y_test,subject_test] 
## and [X_train,Y_train,subject_train] and the activity labels and features need to be read and stored in
## Activity_labels and features.
library(dplyr)

#combining the test and training data and giving colnames.
Combined<-rbind(X_train,X_test)
names<-unlist(features[,2])
colnames(Combined)<-names
#combining subject and activity codes and naming them.
Combined_activitycodes<-rbind(y_train,y_test)
Combined_subject<-rbind(subject_train,subject_test)
Combined1<-cbind(Combined_activitycodes,Combined_subject)
colnames(Combined1)<-c("Activity_Code","Subject_Code")
#combining all to create comprehensive data set.
Merged_data<-cbind(Combined1,Combined)

#-----------------------------------------------------------------------------------------------------------------
#####Step2: Extracts only the measurements on the mean and standard deviation for each measurement. 
##This data set will be named Tidy_Data
colnames_select<-grep("mean|std",colnames(Merged_data))
tidy_data<-Merged_data[,c(1,2,colnames_select)]
head(tidy_data)

#-----------------------------------------------------------------------------------------------------------------
#####Step 3:Uses descriptive activity names to name the activities in the data set.

#extract activity codes into tmp vector
tmp<-tidy_data$Activity_Code
#rename each row according to the code referring to activity_labels
tmp <- activity_labels[tidy_data$Activity_Code, 2]
#join this to our tidy_data 
tidy_data<-cbind(tmp,tidy_data)
#giving a name to added colomn
names(tidy_data)[1]<-"Activity"

#-----------------------------------------------------------------------------------------------------------------
#####Step4: Appropriately labels the data set with descriptive variable names.

#Already appropriately named in steps above. also refer codebook to interpret the colnames.

#-----------------------------------------------------------------------------------------------------------------
#####Step5: From the data set in step 4, creates a second, independent tidy data set with the average of each 
#           variable for each activity and each subject. We will call this tidy_avg.

tidy_avg<-tidy_data %>% group_by(Subject_Code,Activity) %>% summarise_all(funs(mean))
tidy_avg<-tidy_avg[!is.na(tidy_avg$Activity),]

#we will write this dataset to a text file
write.table(tidy_avg, "tidy_avg.txt", row.name=FALSE)
