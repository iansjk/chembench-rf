chembench-rf
============
This is a collection of R scripts that provide Chembench's Random Forest
functionality.

The `RFModel.R` script creates a Random Forest model from a dataset file (a
`.x` file) and its associated activity file (a `.a` file).

The scripts require the R packages `randomForest` and `optparse`. In addition,
the helper scripts `ReadActivityFile.R` and `ReadXFile.R` must be placed in the
same directory as the `RFModel.R` executable script.

