# I need to call this package because I need to use some of the functions in the final steps of the assignment
library(dplyr)

# These queries are to read in the training data and test data. I'm also reading in the data description and activity labels
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

variablenames <- read.table("./UCI HAR Dataset/features.txt")

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#1) For the 1st part of the task, I merged the training and the test data sets to create one big data set.
Xtotal <- rbind(Xtrain, Xtest)
Ytotal <- rbind(Ytrain, Ytest)
Subtotal <- rbind(Subtrain, Subtest)

#2) The point of the below code is to extract only the measurements on the mean and standard deviation for each measurement.
selectvar <- variablenames[grep("mean\\(\\)|std\\(\\)",variablenames[,2]),]
Xtotal <- Xtotal[,selectvar[,1]]

#3) For the 3rd task, I need to use descriptive activity names to name the activities in the data set
colnames(Ytotal) <- "activity"

Ytotal$activitylabel <- factor(Ytotal$activity, labels = as.character(activitylabels[,2]))

activitylabel <- Ytotal[,-1]

#4) This step is to appropriately label the data set with descriptive variable names.
colnames(Xtotal) <- variablenames[selectvar[,1],2]

#5) For the final step, I needed to take the data set from step 4 and create a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Subtotal) <- "subject"
total <- cbind(Xtotal, activitylabel, Subtotal)
totalmean <- total %>% 
                group_by(activitylabel, subject) %>% 
                summarize_all(funs(mean))
write.table(totalmean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)