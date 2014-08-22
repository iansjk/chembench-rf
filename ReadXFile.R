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
ReadXFile <- function(input) {
    # first line is "x y" where x is number of rows and y is number of cols
    header <- as.numeric(read.table(input, nrows = 1, colClasses = "numeric"))
    numRows <- header[1]
    numCols <- header[2]

    # second line contains the names of descriptors
    descriptorNames <- as.character(read.table(input, skip = 1, nrows = 1,
                                               colClasses = "character"))

    # read the actual data starting on line 3
    dataFrame <- read.table(input, skip = 2, stringsAsFactors = FALSE)

    # column 1 of dataFrame contains the row indices (that might not be
    # contiguous, as some could have ended up in the test set).
    # column 2 of dataFrame contains the row labels.
    # adjust dataFrame so it contains the right row labels and column names.
    compoundNames <- as.character(dataFrame[, 2])
    dataFrame <- subset(dataFrame, select = -c(1, 2))  # drop first two cols
    row.names(dataFrame) <- compoundNames
    names(dataFrame) <- descriptorNames

    # check that the first line of the X file accurately represents the number
    # of rows and columns
    if (nrow(dataFrame) != numRows || ncol(dataFrame) != numCols) {
        stop(paste("Expected", numRows, "rows and", numCols, "cols but got",
                   nrow(dataFrame), "rows and", ncol(dataFrame), "cols"))
    }

    return(dataFrame)
}

