# Codebook
Codebook was generated on 2016-09-3 during the same process that generated the dataset.See run_analysis.r for
details on dataset creation.

## Steps of Transformation
1. Download the data and read the files in the train dataset and the test dataset
 * use download.file() and read.table() function 
2. Merge the train and test sets following the order--first train,then test
 * rename the column name: subject, activityNum
 * convert the merged dataset into data table, and set 'subject','activityNum' as its key
 * the merged data is called dt
 * use rbind(), cbind(), rename(), setkey() function
3. Extracts only the measurements on the mean and standard deviation for each measurement
 * use regular expression and grepl() function to extract the corresponding features from 'feature.txt' file
 * extract data from dt, called dt_part
 * use grepl(), paste0() function and column selection in data table
4. Uses descriptive activity names to name the activities in the data set
 * read 'activity_label.txt' file, and rename its columns
 * merge dt_part and activity_label.txt by featureCode
5. Create a new tidy data set with the average variable for each activity and each subject




## Variable list and descriptions of the tidy dataset
| Variable Name  |     Description    |
| -------------  | -----------------  |
|  Subject       | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.|
|  Activity      | Activity name                 |
|  featDomain    | Feature: Time domain signal or frequency domain signal (Time or Freq)                   |
| featInstrument | Feature: Measuring instrument (Accelerometer or Gyroscope)                   |
|featAcceleration| Feature: Acceleration signal (Body or Gravity)                   |
|  featVariable  | Feature: Variable (Mean or SD)                   |
|  featJerk      | Feature: Jerk signal                   |
|  featMagnitude | Feature: Magnitude of the signals calculated using the Euclidean norm                   |
|  featAxis      | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)                   |
|  featCount     | Feature: Count of data points used to compute average                   |
|  featAverage   | Feature: Average of each variable for each activity and each subject                  |

## Dataset structure
```r
str(dtTidy) 
```

```
Classes ‘data.table’ and 'data.frame':	11880 obs. of  11 variables:
 $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity        : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ featDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
 $ featAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
 $ featInstrument  : Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ featJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
 $ featMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
 $ featVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
 $ featAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
 $ count           : int  50 50 50 50 50 50 50 50 50 50 ...
 $ average         : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
 - attr(*, "sorted")= chr  "subject" "activity" "featDomain" "featAcceleration" ...
 - attr(*, ".internal.selfref")=<externalptr> 
```

## List the key variable in the data table
```r
key(dtTidy)
```

```
[1] "subject"          "activity"         "featDomain"       "featAcceleration"
[5] "featInstrument"   "featJerk"         "featMagnitude"    "featVariable"    
[9] "featAxis"   
```

## List all possible combinations of features
```r
dtTidy[, .N, by = c(names(dtTidy)[grep("^feat", names(dtTidy))])]
```

```
    featDomain featAcceleration featInstrument featJerk featMagnitude featVariable
 1:       Time               NA  Accelerometer       NA            NA         Mean
 2:       Time               NA  Accelerometer       NA            NA         Mean
 3:       Time               NA  Accelerometer       NA            NA         Mean
 4:       Time               NA  Accelerometer       NA            NA           SD
 5:       Time               NA  Accelerometer       NA            NA           SD
 6:       Time               NA  Accelerometer       NA            NA           SD
 7:       Time               NA  Accelerometer       NA     Magnitude         Mean
 8:       Time               NA  Accelerometer       NA     Magnitude           SD
 9:       Time               NA  Accelerometer     Jerk            NA         Mean
10:       Time               NA  Accelerometer     Jerk            NA         Mean
11:       Time               NA  Accelerometer     Jerk            NA         Mean
12:       Time               NA  Accelerometer     Jerk            NA           SD
13:       Time               NA  Accelerometer     Jerk            NA           SD
14:       Time               NA  Accelerometer     Jerk            NA           SD
15:       Time               NA  Accelerometer     Jerk     Magnitude         Mean
16:       Time               NA  Accelerometer     Jerk     Magnitude           SD
17:       Time             Body  Accelerometer       NA            NA         Mean
18:       Time             Body  Accelerometer       NA            NA         Mean
19:       Time             Body  Accelerometer       NA            NA         Mean
20:       Time             Body  Accelerometer       NA            NA           SD
21:       Time             Body  Accelerometer       NA            NA           SD
22:       Time             Body  Accelerometer       NA            NA           SD
23:       Time             Body  Accelerometer       NA     Magnitude         Mean
24:       Time             Body  Accelerometer       NA     Magnitude           SD
25:       Time             Body  Accelerometer     Jerk            NA         Mean
26:       Time             Body  Accelerometer     Jerk            NA         Mean
27:       Time             Body  Accelerometer     Jerk            NA         Mean
28:       Time             Body  Accelerometer     Jerk            NA           SD
29:       Time             Body  Accelerometer     Jerk            NA           SD
30:       Time             Body  Accelerometer     Jerk            NA           SD
31:       Time             Body  Accelerometer     Jerk     Magnitude         Mean
32:       Time             Body  Accelerometer     Jerk     Magnitude           SD
33:       Time          Gravity  Accelerometer       NA            NA         Mean
34:       Time          Gravity  Accelerometer       NA            NA         Mean
35:       Time          Gravity  Accelerometer       NA            NA         Mean
36:       Time          Gravity  Accelerometer       NA            NA           SD
37:       Time          Gravity  Accelerometer       NA            NA           SD
38:       Time          Gravity  Accelerometer       NA            NA           SD
39:       Time          Gravity  Accelerometer       NA     Magnitude         Mean
40:       Time          Gravity  Accelerometer       NA     Magnitude           SD
41:       Freq               NA      Gyroscope       NA            NA         Mean
42:       Freq               NA      Gyroscope       NA            NA         Mean
43:       Freq               NA      Gyroscope       NA            NA         Mean
44:       Freq               NA      Gyroscope       NA            NA           SD
45:       Freq               NA      Gyroscope       NA            NA           SD
46:       Freq               NA      Gyroscope       NA            NA           SD
47:       Freq               NA      Gyroscope       NA     Magnitude         Mean
48:       Freq               NA      Gyroscope       NA     Magnitude           SD
49:       Freq               NA      Gyroscope     Jerk     Magnitude         Mean
50:       Freq               NA      Gyroscope     Jerk     Magnitude           SD
51:       Freq             Body      Gyroscope       NA            NA         Mean
52:       Freq             Body      Gyroscope       NA            NA         Mean
53:       Freq             Body      Gyroscope       NA            NA         Mean
54:       Freq             Body      Gyroscope       NA            NA           SD
55:       Freq             Body      Gyroscope       NA            NA           SD
56:       Freq             Body      Gyroscope       NA            NA           SD
57:       Freq             Body      Gyroscope       NA     Magnitude         Mean
58:       Freq             Body      Gyroscope       NA     Magnitude           SD
59:       Freq             Body      Gyroscope     Jerk            NA         Mean
60:       Freq             Body      Gyroscope     Jerk            NA         Mean
61:       Freq             Body      Gyroscope     Jerk            NA         Mean
62:       Freq             Body      Gyroscope     Jerk            NA           SD
63:       Freq             Body      Gyroscope     Jerk            NA           SD
64:       Freq             Body      Gyroscope     Jerk            NA           SD
65:       Freq             Body      Gyroscope     Jerk     Magnitude         Mean
66:       Freq             Body      Gyroscope     Jerk     Magnitude           SD
    featDomain featAcceleration featInstrument featJerk featMagnitude featVariable
    featAxis   N
 1:        X 180
 2:        Y 180
 3:        Z 180
 4:        X 180
 5:        Y 180
 6:        Z 180
 7:       NA 180
 8:       NA 180
 9:        X 180
10:        Y 180
11:        Z 180
12:        X 180
13:        Y 180
14:        Z 180
15:       NA 180
16:       NA 180
17:        X 180
18:        Y 180
19:        Z 180
20:        X 180
21:        Y 180
22:        Z 180
23:       NA 180
24:       NA 180
25:        X 180
26:        Y 180
27:        Z 180
28:        X 180
29:        Y 180
30:        Z 180
31:       NA 180
32:       NA 180
33:        X 180
34:        Y 180
35:        Z 180
36:        X 180
37:        Y 180
38:        Z 180
39:       NA 180
40:       NA 180
41:        X 180
42:        Y 180
43:        Z 180
44:        X 180
45:        Y 180
46:        Z 180
47:       NA 180
48:       NA 180
49:       NA 180
50:       NA 180
51:        X 180
52:        Y 180
53:        Z 180
54:        X 180
55:        Y 180
56:        Z 180
57:       NA 180
58:       NA 180
59:        X 180
60:        Y 180
61:        Z 180
62:        X 180
63:        Y 180
64:        Z 180
65:       NA 180
66:       NA 180
    featAxis   N
```

## Save to file
Save data table objects to a tab-delimited text file called `tidy_data.txt`

```r
write.table(dtTidy, './data/UCI HAR Dataset/tidy_data.txt', quote = FALSE, sep = '\t')
```



