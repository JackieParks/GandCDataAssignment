##Dowload the zip file

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/phone.zip")
## Date and Time of download
## "2017-12-18 09:51:56 EST"

##Unzip it
unzip("./data/phone.zip", exdir="./data/phones")

## Read the test subject id file into a data frame, subject_test.txt
testsubjects=readLines("./data/phones/UCI HAR Dataset/test/subject_test.txt")
testsubjectdf = as.data.frame(do.call(rbind, strsplit(testsubjects, split=" ")), stringsAsFactors=FALSE)
## Name the column "subjectid" since it contains the ids of each subject
names(testsubjectdf)="subjectid"

## Read the test activity file into a dataframe,  y_test.txt
testactivity=readLines("./data/phones/UCI HAR Dataset/test/y_test.txt")
testactivitydf = as.data.frame(do.call(rbind, strsplit(testactivity, split=" ")), stringsAsFactors=FALSE)
##Name the column Activity
names(testactivitydf)="activity"

##Read X-test file into dataframe, X_test.txt
testinfo <- read.table("./data/phones/UCI HAR Dataset/test/X_test.txt", sep = "" , header = F ,   na.strings ="", stringsAsFactors= F)


## Bind all of the columns for the test files into one dataframe
alltestinfo<- bind_cols(testsubjectdf, testactivitydf, testinfo)

## Read features file to get column names, features.txt
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
colnames(alltraininfo)[3:563] = as.character(featuresdf[,2])


## Merge the train and test data using rbind
allinfo<-rbind(alltraininfo, alltestinfo)

## Select columns with mean and std in the name
selinfo<-allinfo[ , (grepl( "std" , names( allinfo ))|grepl("[Mm]ean", names(allinfo))| grepl("activity", names(allinfo))|grepl("subjectid", names(allinfo))) ]


## Give activity variables meaningful names
selinfo$activity= gsub("1", "walking", selinfo$activity)
selinfo$activity= gsub("2", "walkingupstairs", selinfo$activity)
selinfo$activity= gsub("3", "walkingdownstairs", selinfo$activity)
selinfo$activity= gsub("4", "sitting", selinfo$activity)
selinfo$activity= gsub("5", "standing", selinfo$activity)
selinfo$activity= gsub("6", "laying", selinfo$activity)

##selinfo is the first required dataset as a data frame
## Write it to a csv file called selinfo
write.table(selinfo, "./data/selinfo.csv", row.names = FALSE)

## Group the data by subjectid and activity, take the mean of all the other columns, i.e. not subject id and activity
selmean <- selinfo %>% group_by(subjectid, activity) %>% select(-subjectid, -activity) %>% summarise_all(funs(mean))
## cast result to a dataframe
selmeandf=as.data.frame(selmean)

## write data frame to a csv file called selmean
write.table(selmean, "./data/selmean.txt", row.names = FALSE)



