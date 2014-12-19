# In R you need first to load the whole dataset in memory
# and then subselecting. If the dataset is very large, it might
# be not worthy loading everything first to keep only a subset.
#
# With these set of functions we take advantage of 'awk' tool
# to read the dataset line by line and subsetting according to
# index of rows and colums. The output of 'awk' is then
# provided as input to R (see example) 
#
# @require  awt

## @param   idx         row index set to subset
## @param   filename    valid path
lazy.subset.by.row <- function(idx, filename) {
  rows <- paste(as.character(idx), collapse=",")
  command <- paste("awk \"BEGIN{split(\\\"", rows, "\\\", a, \\\",\\\")}",
                   "{for(i in a) if (NR==a[i]) print \\$0}\"", sep="")
  pipe <- paste(command, filename, sep=" ")
  list(command=command,
       pipe=pipe(pipe))
}

## @param   idx         column index set to subset
## @param   filename    valid path
lazy.subset.by.column <- function(idx, filename, sep=",") {
  columns <- paste(as.character(idx), collapse=",")
  command <- paste("awk \"BEGIN{FS=\\\"", sep, "\\\";split(\\\"", columns, "\\\", a, \\\",\\\")}",
                   "{for(i in a) {printf(\\\"%s\\\", \\$a[i]); if(i<", length(idx), ") printf(\\\"%s\\\", FS)}; print \\\"\\\"}\"", sep="")
  pipe <- paste(command, filename, sep=" ")
  list(command=command,
       pipe=pipe(pipe))
}


## @param   filename    valid path
## @param   r.idx       row index set to subset
## @param   c.idx       column index set to subset
## @param   sep         if subsetting by column, sep is the field separator
lazy.subset <- function(filename, r.idx=NULL, c.idx=NULL, sep=",") {
  out <- NULL
  if (is.null(c.idx) && !is.null(r.idx)) {out <- lazy.subset.by.row(idx=r.idx, filename=filename)}
  if (!is.null(c.idx) && is.null(r.idx)) {out <- lazy.subset.by.column(idx=c.idx, filename=filename, sep=sep)}
  if (!is.null(c.idx) && !is.null(r.idx)) {
    rows <- paste(as.character(r.idx), collapse=",")
    columns <- paste(as.character(c.idx), collapse=",")
    command <- paste("awk \"BEGIN{split(\\\"", rows, "\\\", a, \\\",\\\");FS=\\\"", sep, "\\\";",
                     "split(\\\"", columns, "\\\", b, \\\",\\\")}",
                     "{for(i in a) if (NR==a[i]) {",
                     "for(j in b) {printf(\\\"%s\\\", \\$b[j]); if(j<", length(c.idx), ") printf(\\\"%s\\\", FS)}; print \\\"\\\"",
                     "}}\"", sep="")
    out <- list(command=command,
                pipe=pipe(paste(command, filename, sep=" ")))
  }
  out
}
