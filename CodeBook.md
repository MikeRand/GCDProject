CodeBook for tidydata.txt
=========================

Michael Rand

See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
for description of original dataset.



Variables
---------
1. subject - numeric
  * Represents a given individual
  * Factor with 30 levels (1:30)
  
2. activity - character
  * Describes what person was doing when measurement taken
  * Factor with 6 character levels
    - WALKING
    - WALKING_UPSTAIRS
    - WALKING_DOWNSTAIRS
    - SITTING
    - STANDING
    - LAYING

3. variable - character
  * Describes the original data metric averaged in tidy data
  * Factor with 66 character levels
    - tBodyAccMeanX
    - tBodyAccMeanY
    - tBodyAccMeanZ
    - tBodyAccStdX
    - tBodyAccStdY
    - tBodyAccStdZ
    - tGravityAccMeanX
    - tGravityAccMeanY
    - tGravityAccMeanZ
    - tGravityAccStdX
    - tGravityAccStdY
    - tGravityAccStdZ
    - tBodyAccJerkMeanX
    - tBodyAccJerkMeanY
    - tBodyAccJerkMeanZ
    - tBodyAccJerkStdX
    - tBodyAccJerkStdY
    - tBodyAccJerkStdZ
    - tBodyGyroMeanX
    - tBodyGyroMeanY
    - tBodyGyroMeanZ
    - tBodyGyroStdX
    - tBodyGyroStdY
    - tBodyGyroStdZ
    - tBodyGyroJerkMeanX
    - tBodyGyroJerkMeanY
    - tBodyGyroJerkMeanZ
    - tBodyGyroJerkStdX
    - tBodyGyroJerkStdY
    - tBodyGyroJerkStdZ
    - tBodyAccMagMean
    - tBodyAccMagStd
    - tGravityAccMagMean
    - tGravityAccMagStd
    - tBodyAccJerkMagMean
    - tBodyAccJerkMagStd
    - tBodyGyroMagMean
    - tBodyGyroMagStd
    - tBodyGyroJerkMagMean
    - tBodyGyroJerkMagStd
    - fBodyAccMeanX
    - fBodyAccMeanY
    - fBodyAccMeanZ
    - fBodyAccStdX
    - fBodyAccStdY
    - fBodyAccStdZ
    - fBodyAccJerkMeanX
    - fBodyAccJerkMeanY
    - fBodyAccJerkMeanZ
    - fBodyAccJerkStdX
    - fBodyAccJerkStdY
    - fBodyAccJerkStdZ
    - fBodyGyroMeanX
    - fBodyGyroMeanY
    - fBodyGyroMeanZ
    - fBodyGyroStdX
    - fBodyGyroStdY
    - fBodyGyroStdZ
    - fBodyAccMagMean
    - fBodyAccMagStd
    - fBodyBodyAccJerkMagMean
    - fBodyBodyAccJerkMagStd
    - fBodyBodyGyroMagMean
    - fBodyBodyGyroMagStd
    - fBodyBodyGyroJerkMagMean
    - fBodyBodyGyroJerkMagStd
    
4. value - numeric
  * Mean of raw data for given subject/activity/variable group
  * Scaled to be between [-1, 1]
  
Process
-------
* tidydata.txt created by running run_analysis.R script.
* Original set of 561 variables reduced to 66 variables. Only
  variables with either "mean()" or "std()" in the name chosen.
* Variables renamed to camel case with no special characters
* Example: "variable-mean()-X" in raw data becomes "variableMeanX"
  in tidy data.