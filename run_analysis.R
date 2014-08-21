Main <- function(downloadDirectory, outputDirectory) {
  # Run project tiday data creation script.
  dataDirectory <- GetUnprocessedData(downloadDirectory)
  rawDataFrame  <- CreateRawDataFrame(dataDirectory)
  tidyDataFrame <- CreateTidyDataFrame(rawDataFrame)
  OutputTidyData(tidyDataFrame, outputDirectory)
}

GetUnprocessedData <- function(downloadDirectory) {
  # Download and unzip unprocessed data (if necessary).
  #
  # Args:
  #   downloadDirectory
  #
  # Returns:
  #   string - data directory
  if (!file.exists(downloadDirectory)) {
    dir.create(downloadDirectory)
  }
  
  zipFile <- paste(downloadDirectory, "uci.zip", sep="/")
  if (!file.exists(zipFile)) {
    urlHead <- "https://d396qusza40orc.cloudfront.net"
    urlTail <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    url <- paste(urlHead, urlTail, sep="/")
    download.file(url, destfile=zipFile, method="curl")
  }
  
  dataDirectory <- paste(downloadDirectory, "ucidata", sep="/")
  if (file.exists(dataDirectory)) {
    unlink(dataDirectory, recursive=TRUE, force=TRUE)
  }
  unzip(zipFile, exdir=downloadDirectory)
  oldDirectory <- paste(downloadDirectory, "UCI HAR Dataset", sep="/")
  file.rename(oldDirectory, dataDirectory)
  dataDirectory
}

########################################################################
# CreateRawDataFrame and support functions
########################################################################

CreateRawDataFrame <- function(dataDirectory) {
  # Return RawDataFrame of merged data sets
  #
  # Args:
  #   dataDirectory - root directory of zip extract
  #
  # Return:
  #   rawDataFrame
  featureInformation  <- GetFeatureInformation(dataDirectory)  
  activityInformation <- GetActivityInformation(dataDirectory)  
  rawDataFrame        <- GetRawDataSegment(dataDirectory,
                                           'test',
                                           featureInformation,
                                           activityInformation)
  rawDataFrame <- rbind(rawDataFrame,
                        GetRawDataSegment(dataDirectory,
                                          'train',
                                          featureInformation,
                                          activityInformation)
                        )
  rawDataFrame
}
  
GetFeatureInformation <- function(dataDirectory) {
  # Return feature information labels and class ids.
  #
  # Args:
  #   dataDirectory - root directory of zip
  #
  # Returns:
  #   list with two attributes
  #   names - vector of column names
  #   colClasses - vector of column classes
  file <- paste(dataDirectory, "features.txt", sep="/")
  colNames <- c("id", "name")
  colClass <- c("NULL", "character")
  features <- read.table(file,
                         header=FALSE,
                         sep=" ",
                         col.names=colNames,
                         colClasses=colClass)
  features <- features[,1]
  featureNames <- sapply(features,
                         GetFeatureColumnName,
                         USE.NAMES=FALSE)
  featureColClasses <- sapply(features,
                              GetFeatureColumnClass,
                              USE.NAMES=FALSE)
  featureInformation <- list(names=featureNames,
                             colClasses=featureColClasses)
  featureInformation
}

GetFeatureColumnName <- function(name) {
  # Strip dashes and parentheses, capitalize function names
  #
  # Args:
  #   name - raw feature column name
  #
  # Returns:
  #   a nice column name (camel case, no special characters)
  niceName <- gsub("-", "", name, fixed=TRUE)
  if (grepl("mean()", name, fixed=TRUE)) {
    niceName <- gsub("mean()", "Mean", niceName, fixed=TRUE)
  } else if (grepl("std()", name, fixed=TRUE)) {
    niceName <- gsub("std()", "Std", niceName, fixed=TRUE)
  }
  niceName
}

GetFeatureColumnClass <- function(name) {
  # Strip dashes and parentheses, capitalize function names
  #
  # Args:
  #   name - raw feature column name
  #
  # Returns:
  #   a nice column name (camel case, no special characters)
  colClass <- "NULL"
  if (grepl("mean()", name, fixed=TRUE)) {
    colClass <- "numeric"
  } else if (grepl("std()", name, fixed=TRUE)) {
    colClass <- "numeric"
  }
  colClass
}

GetActivityInformation <- function(dataDirectory) {
  # Return activity levels and labels.
  #
  # Args:
  #   dataDirectory - root directory of zip
  #
  # Returns:
  #   list with two attributes
  #   levels - vector of levels for activities
  #   labels - vector of labels for activities
  file <- paste(dataDirectory, "activity_labels.txt", sep="/")
  colNames <- c("level", "label")
  colClass <- c("integer", "character")
  activity <- read.table(file,
                         header=FALSE,
                         sep=" ",
                         col.names=colNames,
                         colClasses=colClass)
  activityInformation <- list(levels=activity[,1], labels=activity[,2])
  activityInformation
}

GetRawDataSegment <- function(dataDirectory,
                              segment,
                              featureInfo,
                              activityInfo) {
  # Return activity levels and labels.
  #
  # Args:
  #   dataDirectory - root directory of zip
  #
  # Returns:
  #   list with two attributes
  #   levels - vector of levels for activities
  #   labels - vector of labels for activities
  rawDataSegment <- GetFeatureData(dataDirectory, segment, featureInfo)

  rawDataSegment <- cbind(rawDataSegment,
                          GetSubjectData(dataDirectory, segment))
  rawDataSegment <- cbind(rawDataSegment,
                          GetActivityData(dataDirectory,
                                          segment,
                                          activityInfo))
  rawDataSegment
}

GetFeatureData <- function(dataDirectory, segment, featureInfo) {
  # Get feature data from given segment.
  #
  # Args:
  #   dataDirectory - root of zip
  #   segment - name of segment (used for files)
  #   featureInfo - list with names and colClasses elements
  #
  # Returns:
  #   dataframe with mean and std features
  segmentDirectory <- paste(dataDirectory, segment, sep="/")
  fileName <- paste("X_", segment, ".txt", sep="")
  file <- paste(segmentDirectory, fileName, sep="/")
  featureDataFrame <- read.table(file,
                                 col.names=featureInfo$names,
                                 colClasses=featureInfo$colClasses,
                                 strip.white=TRUE)
  featureDataFrame
}

GetSubjectData <- function(dataDirectory, segment) {
  # Get subject data from given segment.
  #
  # Args:
  #   dataDirectory - root of zip
  #   segment - name of segment (used for files)
  #
  # Returns:
  #   dataframe with subject
  segmentDirectory <- paste(dataDirectory, segment, sep="/")
  fileName <- paste("subject_", segment, ".txt", sep="")
  file <- paste(segmentDirectory, fileName, sep="/")
  subjectDataFrame <- read.table(file,
                                 col.names=c("subject"),
                                 colClasses=c("numeric"),
                                 strip.white=TRUE)
  subjectDataFrame[,1] <- factor(subjectDataFrame[,1])
  subjectDataFrame
}

GetActivityData <- function(dataDirectory, segment, activityInfo) {
  # Get activity data from given segment.
  #
  # Args:
  #   dataDirectory - root of zip
  #   segment - name of segment (used for files)
  #
  # Returns:
  #   dataframe with subject
  segmentDirectory <- paste(dataDirectory, segment, sep="/")
  fileName <- paste("y_", segment, ".txt", sep="")
  file <- paste(segmentDirectory, fileName, sep="/")
  activityDataFrame <- read.table(file,
                                  col.names=c("activity"),
                                  colClasses=c("numeric"),
                                  strip.white=TRUE)
  activityDataFrame[,1] <- factor(activityDataFrame[,1],
                                  levels=activityInfo$levels,
                                  labels=activityInfo$labels)
  activityDataFrame
}

########################################################################
# Process Tidy Data
########################################################################

CreateTidyDataFrame <- function(rawDataFrame) {
  # Return tidy data with mean of variables by subject / activity
  #
  # Args:
  #   rawDataFrame - data frame with features, subject, and activity
  #
  # Returns:
  #   tidyDataFrame with 4 columns:
  #      subject
  #      activity
  #      variable
  #      value
  N <- length(names(rawDataFrame)) - 2
  measures <- names(rawDataFrame)[1:N]
  meltedData <- melt(rawDataFrame,
                     id=c("subject", "activity"),
                     measure.vars=measures)
  tidyDataFrame <- aggregate(value~subject+activity+variable,
                             data=meltedData,
                             FUN="mean")
  tidyDataFrame
}

OutputTidyData <- function(tidyDataFrame, outputDirectory) {
  # Write tidyDataFrame to output directory as tidydata.txt using
  # write.table
  #
  # Args:
  #   tidyDataFrame - the table to write
  #   outputDirectory - directory into which to write tidydata.csv
  file <- paste(outputDirectory, "tidydata.txt", sep="/")
  write.table(tidyDataFrame, file, row.names=FALSE)
}

########################################################################
# Run main program
########################################################################
require(reshape2)
downloadDirectory <- getwd()         # Use slashes
outputDirectory   <- "~/Projects/gcd/GCDProject"   # Use slashes
Main(downloadDirectory, outputDirectory)