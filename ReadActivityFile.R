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
ReadActivityFile <- function(input) {
    # activity files can have headers, but don't have to; if the header is
    # absent, then the columns "Compound", "Activity" are assumed.
    # check the first row, second column to see if a header is present: if it
    # is, it will be a character scalar, and if not, it should be numeric.
    firstLine <- read.table(input, nrows = 1, header = FALSE,
                            stringsAsFactors = FALSE)

    colNames <- c("Compound", "Activity")
    linesToSkip <- 0
    if (is.character(firstLine[1, 2])) {
        # if header is present, prefer the column names of the header
        colNames <- firstLine[1, ]
        linesToSkip <- 1
    }

    dataFrame <- read.table(input, skip = linesToSkip,
                            colClasses = c("character", "numeric"))
    names(dataFrame) <- colNames

    return(dataFrame)
}

