# this code gets and clean the aimed dataset
library(reshape2)

# merge the dataset of train and test
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubject, Xtrain, ytrain)

Xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubject, Xtest, ytest)

# extract only the data on mean and standard deviation
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
features_select <- grep(".*mean.*|.*std.*", features[,2])
Xtrain_want <- Xtrain[,features_select]
Xtest_want <- Xtest[,features_select]
train_want <- cbind(trainSubject, ytrain, Xtrain_want)
test_want <- cbind(testSubject, ytest, Xtest_want)

# use descriptive activity names to name the activities in the data set
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")

# create an intermediate data set and label the data set with descriptive activity names
data_want <- rbind(train_want, test_want)
colnames(data_want) <- c("subject", "activity",features[features_select,2])

# create the final dataset
data_want_melt <- melt(data_want, id=c("subject","activity"))
data_want_mean <- dcast(data_want_melt, subject+activity ~ variable, mean)

# output the data set
write.table(data_want_mean, "Final_tidy_data.txt", row.names=F, quote=F)
