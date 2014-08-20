GCDProject
==========

Course Project for Getting and Cleaning Data

Assumptions
-----------

1. Platform that uses method "curl" to download file
  - change line 27 if curl is not necessary
2. reshape2 installed (used to create tidy data)

How to use
----------

1. Open run_analysis.R
2. Set download directory on line 280
3. Set tidy data output directory on line 281
4. Source run_analysis.R
5. Review output in tidydata.txt

Note: if zip file is already in download directory,
script will not attempt to download again.

Code Sections
-------------

1. Download (if necessary)
2. Create Raw Data Frame
3. Create Tidy Data Frame
4. Output Tidy Data Frame

Modifications
-------------

If different columns are desired (e.g. kurtosis and skew),
changing the GetFeatureColumnClass and GetFeatureColumnName
will enable a different set of columns to be selected.