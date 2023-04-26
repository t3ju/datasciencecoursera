options(warn=-1)  
library(data.table)
options(warn=0)

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "zipfile.zip", method = "curl")
unzip("zipfile.zip")
setwd("./UCI HAR Dataset")

subject_train <- read.table("./train/subject_train.txt", header = FALSE)
names(subject_train)<-"subjectID"

subject_test <- read.table("./test/subject_test.txt", header = FALSE)
names(subject_test)<-"subjectID"

y_train <- read.table("./train/y_train.txt", header = FALSE)
names(y_train) <- "activity"

y_test <- read.table("./test/y_test.txt", header = FALSE)
names(y_test) <- "activity"


FeatureNames<-read.table("features.txt")

X_train <- read.table("./train/X_train.txt", header = FALSE)
names(X_train) <- FeatureNames$V2

X_test <- read.table("./test/X_test.txt", header = FALSE)
names(X_test) <- FeatureNames$V2


train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
alldata <- rbind(train, test)


meancol<-alldata[,grep('mean()', names(alldata), fixed=TRUE)]
stdcol<-alldata[,grep('std()', names(alldata), fixed=TRUE)]
keycol<-alldata[,(1:2)]
meanstd_data<-cbind(keycol,meancol,stdcol)


actlbl<-read.table("activity_labels.txt")
alldata$activity <- factor(alldata$activity, labels=actlbl$V2)



names(alldata)<-gsub("tBody","TimeDomainBody",names(alldata), fixed=TRUE)
names(alldata)<-gsub("tGravity","TimeDomainGravity",names(alldata), fixed=TRUE)
names(alldata)<-gsub("fBody","FrequencyDomainBody",names(alldata), fixed=TRUE)
names(alldata)<-gsub("Acc","Acceleration",names(alldata), fixed=TRUE)
names(alldata)<-gsub("Gyro", "AngularVelocity",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-XYZ","3AxialSignals",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-X","XAxis",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-Y","YAxis",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-Z","ZAxis",names(alldata), fixed=TRUE)
names(alldata)<-gsub("Mag","MagnitudeSignals",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-mean()","MeanValue",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-std()","StandardDeviation",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-mad()","MedianAbsoluteDeviation ",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-max()","LargestValueInArray",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-min()","SmallestValueInArray",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-sma()","SignalMagnitudeArea",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-energy()","EnergyMeasure",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-iqr()","InterquartileRange ",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-entropy()","SignalEntropy",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-arCoeff()","AutoRegresionCoefficientsWithBurgOrderEqualTo4",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-correlation()","CorrelationCoefficient",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-maxInds()", "IndexOfFrequencyComponentWithLargestMagnitude",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-meanFreq()","WeightedAverageOfFrequencyComponentsForMeanFrequency",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-skewness()","Skewness",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-kurtosis()","Kurtosis",names(alldata), fixed=TRUE)
names(alldata)<-gsub("-bandsEnergy()","EnergyOfFrequencyInterval.",names(alldata), fixed=TRUE)

DT<-data.table(alldata)
tidy<-DT[,lapply(.SD,mean),by="activity,subjectID"]
write.table(tidy, file="TidyData.txt", row.name=FALSE, col.names=TRUE)
print ("The script 'run_analysis.R was executed successfully.  As a result, the file TidyData.txt has been saved in the working directory, in folder UCI HAR Dataset.")
rm(list=ls())

