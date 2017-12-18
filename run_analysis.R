##Dowload the zip file

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/phone.zip/")
## Date and Time of download
## "2017-12-18 09:51:56 EST"

##Unzip it
unzip("./data/phone.zip", exdir="./data/phones")

## Put test subjects into a data frame 
testsubjects=readLines("./data/phones/UCI HAR Dataset/test/subject_test.txt")
testsubjectdf = as.data.frame(do.call(rbind, strsplit(testsubjects, split=" ")), stringsAsFactors=FALSE)
## Name the column "subjectid"
names(testsubjectdf)="subjectid"

## Put test activity values into a dataframe
testactivity=readLines("./data/phones/UCI HAR Dataset/test/y_test.txt")
testactivitydf = as.data.frame(do.call(rbind, strsplit(testactivity, split=" ")), stringsAsFactors=FALSE)
##Name the column Activity
names(testactivitydf)="activity"

##Read X-test file into dataframe
testinfo <- read.table("./data/phones/UCI HAR Dataset/test/X_test.txt", sep = "" , header = F ,   na.strings ="", stringsAsFactors= F)


## Bind all of the columns for the test files into one dataframe
alltestinfo<- bind_cols(testsubjectdf, testactivitydf, testinfo)

## Read features file to get column names
features=readLines("./data/phones/UCI HAR Dataset/features.txt")
featuresdf = as.data.frame(do.call(rbind, strsplit(features, split=" ")), stringsAsFactors=FALSE)
##Name the remaining columns of alltestinfo using the features file for the names
colnames(alltestinfo)[3:563] = as.character(featuresdf[,2])


## Repeat all for training datasets
## Read train subject data
trainsubjects=readLines("./data/phones/UCI HAR Dataset/train/subject_train.txt")
trainsubjectdf = as.data.frame(do.call(rbind, strsplit(trainsubjects, split=" ")), stringsAsFactors=FALSE)
## Name the column "subjectid"
names(trainsubjectdf)="subjectid"

## Put train activity values into a dataframe
trainactivity=readLines("./data/phones/UCI HAR Dataset/train/y_train.txt")
trainactivitydf = as.data.frame(do.call(rbind, strsplit(trainactivity, split=" ")), stringsAsFactors=FALSE)
##Name the column Activity
names(trainactivitydf)="activity"

##Read X-train file into dataframe
traininfo <- read.table("./data/phones/UCI HAR Dataset/train/X_train.txt", sep = "" , header = F ,   na.strings ="", stringsAsFactors= F)


## Bind all of the columns for the train files into one dataframe
alltraininfo<- bind_cols(trainsubjectdf, trainactivitydf, traininfo)


##Name the remaining columns of alltraininfo using the features file for the names
colnames(alltestinfo)[3:563] = as.character(featuresdf[,2])



## Merge the train and test data
allinfo<-rbind(alltraininfo, alltestinfo)

## Select columns with mean and std
selinfo<-allinfo[ , (grepl( "std" , names( allinfo ))|grepl("mean", names(allinfo))| grepl("activity", names(allinfo))|grepl("subjectid", names(allinfo))) ]


## Give activity variables meaningful names
selinfo$activity= gsub("1", "walking", selinfo$activity)
selinfo$activity= gsub("2", "walkingupstairs", selinfo$activity)
selinfo$activity= gsub("3", "walkingdownstairs", selinfo$activity)
selinfo$activity= gsub("4", "sitting", selinfo$activity)
selinfo$activity= gsub("5", "standing", selinfo$activity)
selinfo$activity= gsub("6", "laying", selinfo$activity)

##selinfo is the first required dataset as a data frame

## Group the data, take the mean of all columns except subject id and activity
selmean <- selinfo %>% group_by(subjectid, activity) %>% select(-subjectid, -activity) %>% summarise_all(funs(mean))
## cast result to a dataframe
## selmeandf is the second required data set as a data frame
selmeandf=as.data.frame(selmean)



