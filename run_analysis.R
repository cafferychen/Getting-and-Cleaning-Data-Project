### Cleaning and Getting Data Project
require(dplyr)
path = getwd()
file.path(path, 'data','edu.csv')  # file.path() useful!!


## 1.Get the data and read the files
fileUrl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./data')) {dir.create('./data')}
download.file(fileUrl, destfile = './data/UCI.zip', method = 'curl')

# read the subject files
Subject_Train = read.table('./data/UCI HAR Dataset/train/subject_train.txt')  # 21 different train subjects
Subject_Test = read.table('./data/UCI HAR Dataset/test/subject_test.txt')     # 9 different test subjects

# read the acitivity files
Activity_Train = read.table('./data/UCI HAR Dataset/train/y_train.txt')  # activity num for each train subject
Activity_Test = read.table('./data/UCI HAR Dataset/test/y_test.txt')

Train = read.table('./data/UCI HAR Dataset/train/X_train.txt')   # 561 variables
dim(Train) # 7352 by 561
Test = read.table('./data/UCI HAR Dataset/test/X_test.txt')
dim(Test) # 2947 by 561


## 2.Merge the traing and the test sets: first train, then test
# Concatenate the data tables
Subject = rbind(Subject_Train, Subject_Test)
Subject = rename(Subject, subject = V1)   # new name = original col name
Activity = rbind(Activity_Train, Activity_Test)
Activity = rename(Activity, activityNum = V1)

dt = rbind(Train, Test)  # merge the records of the variables from train and test
dim(dt)  # 10299 by 561 

# Merge colums
Sub_Act = cbind(Subject, Activity) # merge subject and activity
dt = cbind(Sub_Act, dt)  # merged data, the final result 
dim(dt)  # 10299 by 563
dt = data.table(dt)
setkey(dt, subject, activityNum)


## 3.Extract only the mean and sd:
# read feature.txt file
Features = read.table('./data/UCI HAR Dataset/features.txt')
Features = rename(Features, featureNum = V1, featureName = V2)
dim(Features)   # 561 by 2, so totally 561 features

# subset only measurements for mu and sd
ms = Features[grepl('mean\\(\\)|std\\(\\)', Features$featureName),]
ms = data.table(ms)
dim(ms)  # 66 by 3: so there are 66 features meeting the requirements

ms$featureCode = paste0('V', ms$featureNum)

select = c(key(dt), ms$featureCode)   # all the columns statisfying the requirements
dt_part = dt[, select, with=FALSE]    # with = FALSE: include the entire col
dim(dt_part)  # 10299 by 68


## 4.Uses descriptive activity names to name the activities in the data set
ActivityNames = read.table('./data/UCI HAR Dataset/activity_labels.txt')
ActivityNames = rename(ActivityNames, activityNum = V1, activityName = V2)

# Merge dt_part and ActivityNames: add the activity name to dt_part
dt_part = merge(dt_part,ActivityNames, by = 'activityNum', all.x = TRUE)
setkey(dt_part, subject,activityNum, activityName)
dim(dt_part)  # 10299 by 69

# melt the data table to reshape it from a short and wide format to a tall and narrow format
dt_part = data.table(melt(dt_part, key(dt_part), variable.name = 'featureCode'))
dim(dt_part) # 679734 by 5, 679734 = 10299 X 66

# merge feature name and feature num from ms by featureCode
# dt_part: featureCode,...
# ms: featureCode,featureName,featureNum
dt_part = merge(dt_part, ms[,list(featureNum,featureCode,featureName)],
                by = 'featureCode', all.x =TRUE)
dim(dt_part)   # 679734 by 7 

# Create two new variables, activity & feature
dt_part$activity = factor(dt_part$activityName)
dt_part$feature = factor(dt_part$featureName)
head(dt_part)
sapply(dt_part,class) # check the data type of each col variable

## 5.Create a new tidy data set with the average variable for each activity and each subject
grepthis <- function(regex){
      grepl(regex, dt_part$feature)
}
n = 2     # feature with 2 categories: start with 't'; start with 'f'
y = matrix(seq(1,n), nrow = n) # 2 by 1 matrix

# new variable: featDomain, Time or Freq
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y))
dt_part$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))

# new variable: featInstrument, Accelerometor or Gyoscope
x = matrix(c(grepthis('^t'), grepthis('^f')), ncol=nrow(y))  # category with 'f' none
dt_part$featInstrument = factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
head(dt_part)

# new variable: featAcceleration, Body or Gravity
x = matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol=nrow(y))
dt_part$featAcceleration = factor(x %*% y, labels=c(NA, "Body", "Gravity"))

# new variable: featVariable, Mean or SD
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol=nrow(y))
dt_part$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))
head(dt_part)

# Features with 1 category
dt_part$featJerk <- factor(grepthis("Jerk"), labels=c(NA, "Jerk"))
dt_part$featMagnitude <- factor(grepthis("Mag"), labels=c(NA, "Magnitude"))

# Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
dt_part$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# check 
r1 <- nrow(dt_part[, .N, by= feature])
r2 <- nrow(dt_part[, .N, by=c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2

# create a tidy data set
setkey(dt_part, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidy <- dt_part[, list(count = .N, average = mean(value)), by=key(dt_part)]
dtTidy  # final result
write.table(dtTidy, './data/UCI HAR Dataset/tidy_data.txt', quote = FALSE, sep = '\t')
x = read.table('./data/UCI HAR Dataset/tidy_data.txt')

## CodeBook
str(dtTidy)
key(dtTidy)
#List all possible combinations of features
dtTidy[, .N, by = c(names(dtTidy)[grep("^feat", names(dtTidy))])]


##########
length(unique(dt_part$featureCode))
dt_part[1:200,1:3, with = FALSE]
View(dt_part[subject == 2])
key(dt_part)

dt_simple = dt_part[ , c(1,2,3,5), with = FALSE]
head(dt_simple)
dt_new = dt_simple[,mean(value), by = 'subject,activityNum,featureCode']
dt_new
head(Features)

