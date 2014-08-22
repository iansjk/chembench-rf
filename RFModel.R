#!/usr/bin/Rscript
#
# Copyright (c) 2014 Ian Kim <iansjk@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
argv <- commandArgs(trailingOnly = FALSE)
kScriptDir <- dirname(sub("--file=", "", argv[grep("--file=", argv)]))
if (length(kScriptDir) == 0 || nchar(kScriptDir) == 0) {
    kScriptDir <- "."  # e.g. when sourced in interactive shell
}
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(randomForest))
source(paste(kScriptDir, "ReadXFile.R", sep = "/"))
source(paste(kScriptDir, "ReadActivityFile.R", sep = "/"))

# TODO make these cmdline parameters later using optparse
datasetFile <- "rfds.x"
activityFile <- "rfds.act"
type <- "regression"
ntree <- 1000
rfObjectFileName <- "forest.rds"
oobFileName <- "oobpreds.csv"

dataset <- ReadXFile(datasetFile)
activity <- ReadActivityFile(activityFile)

# convert activities to factors if performing classification
if (type == "classification") {
    activity <- as.factor(activity)
}

# subset activity vector to contain only compounds that are in the dataset
# (normally the same compounds are in both, i.e. there is no compound that is
# in only one of the two sets. but if descriptor generation fails, then a
# compound could be given in the activity vector but not in the dataset)
activity <- activity[row.names(dataset)]

# generate forest and save it as an RDS file
rf <- randomForest(dataset, y = activity, ntree = ntree)
stopifnot(rf$type == type)  # assert that rf type is what we expected
saveRDS(rf, rfObjectFileName)

# save out-of-bag (oob) predictions
oob <- predict(rf)  # absence of "newData" parameter generates oob data
write.table(oob, file = oobFileName, quote = FALSE, sep = "\t",
            col.names = FALSE)

